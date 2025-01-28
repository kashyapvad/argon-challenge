class ClinicalTrial < ApplicationRecord
  # Associations
  has_many :arm_groups, dependent: :destroy
  has_many :arm_group_interventions, through: :arm_groups
  has_many :interventions, through: :arm_group_interventions
  has_many :outcomes, dependent: :destroy
  has_many :locations, dependent: :destroy

  after_create :generate_embeddings
  after_save :upsert_to_pinecone if -> { embedding_changed? }
  after_destroy :delete_from_pinecone

  def generate_embeddings
    # Trial Data
    combined_text = [
        "nct_id: #{self.nct_id}",
        "org_study_id: #{self.org_study_id}",
        "sponsor_full_name: #{self.sponsor_full_name}",
        "sponsor_class: #{self.sponsor_class}",
        "brief_title: #{self.brief_title}",
        "official_title: #{self.official_title}",
        "overall_status: #{self.overall_status}",
        "brief_summary: #{self.brief_summary}",
        "detailed_description: #{self.detailed_description}",
        "conditions: #{self.conditions.join(' ')}",
        "phases: #{self.phases.join(' ')}",
        "allocation: #{self.allocation}",
        "intervention_model: #{self.intervention_model}",
        "intervention_model_description: #{self.intervention_model_description}",
        "primary_purpose: #{self.primary_purpose}",
        "masking: #{self.masking}",
        "who_masked: #{self.who_masked.join(' ')}",
        "enrollment_count: #{self.enrollment_count}",
        "enrollment_type: #{self.enrollment_type}",
        "eligibility_criteria: #{self.eligibility_criteria}",
        "healthy_volunteers: #{self.healthy_volunteers}",
        "sex: #{self.sex}",
        "minimum_age: #{self.minimum_age}",
        "maximum_age: #{self.maximum_age}",
        "std_ages: #{self.std_ages.join(' ')}",
        "version_holder: #{self.version_holder}"
    ]

    #Arm Group Data
    self.arm_groups.each do |arm_group|
      combined_text + [
        "arm_label: #{arm_group.label}",
        "arm_type: #{arm_group.arm_type}",
        "arm_group_description: #{arm_group.description}",
      ]

      arm_group.interventions.each do |intervention|
        combined_text + [
          "intervention_name: #{intervention.name}",
          "intervention_type: #{intervention.intervention_type}",
          "intervention_description: #{intervention.description}",
        ]
      end
    end

    #Outcome Data
    self.outcomes.each do |outcome|
      combined_text + [
        "outcome_measure: #{outcome.measure}",
        "outcome_type: #{outcome.outcome_type}",
        "outcome_description: #{outcome.description}",
        "outcome_time_frame: #{outcome.time_frame}"
      ]
    end

    #Location Data
    self.locations.each do |location|
      combined_text + [
        "location_facility: #{location.facility}",
        "location_city: #{location.city}",
        "location_country: #{location.country}",
      ]
    end
    text = combined_text.flatten.compact.join("\n")
    self.embedding = EmbeddingService.generate_embeddings_from_openai text
    save!
  end

  private

  def upsert_to_pinecone
    pinecone = ::PineconeClient.new
    vectors = {
      vectors: [
        {
          id: self.id.to_s,
          values: self.embedding,
          metadata: {
            nct_id: self.nct_id,
            brief_title: self.brief_title,
            official_title: self.official_title,
            conditions: self.conditions.join(', '),
            phases: self.phases,
            status: self.overall_status,
            # Add other metadata fields as desired
          }
        }
      ]
    }
    response = pinecone.upsert(vectors)
    unless response.success?
      Rails.logger.error "Failed to upsert ClinicalTrial #{self.id} to Pinecone: #{response.body}"
    end
  end

  def delete_from_pinecone
    pinecone = ::PineconeClient.new
    response = pinecone.delete(id: self.id.to_s)
    unless response.success?
      Rails.logger.error "Failed to delete ClinicalTrial #{self.id} from Pinecone: #{response.body}"
    end
  end
end