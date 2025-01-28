class CreateClinicalTrials < ActiveRecord::Migration[7.2]
  def change
    create_table :clinical_trials do |t|
      # Identification Module
      t.string :nct_id, null: false
      t.string :org_study_id
      t.string :sponsor_full_name
      t.string :sponsor_class
      t.string :brief_title
      t.string :official_title

      # Status Module
      t.date :status_verified_date
      t.string :overall_status
      t.boolean :has_expanded_access
      t.date :start_date
      t.string :start_date_type
      t.date :primary_completion_date
      t.string :primary_completion_date_type
      t.date :completion_date
      t.string :completion_date_type
      t.date :study_first_submit_date
      t.date :study_first_submit_qc_date
      t.date :study_first_post_date
      t.string :study_first_post_date_type
      t.date :last_update_submit_date
      t.date :last_update_post_date
      t.string :last_update_post_date_type

      # Sponsor Collaborators Module
      t.string :responsible_party_type
      t.string :lead_sponsor_name
      t.string :lead_sponsor_class

      # Oversight Module
      t.boolean :is_fda_regulated_drug
      t.boolean :is_fda_regulated_device

      # Description Module
      t.text :brief_summary
      t.text :detailed_description

      # Conditions Module
      t.text :conditions, array: true, default: []

      # Design Module
      t.string :study_type
      t.string :phases, array: true, default: []
      t.string :allocation
      t.string :intervention_model
      t.text :intervention_model_description
      t.string :primary_purpose
      t.string :masking
      t.string :who_masked, array: true, default: []
      t.integer :enrollment_count
      t.string :enrollment_type

      # Eligibility Module
      t.text :eligibility_criteria
      t.boolean :healthy_volunteers
      t.string :sex
      t.string :minimum_age
      t.string :maximum_age
      t.string :std_ages, array: true, default: []

      # Derived Section
      t.string :version_holder

      # Miscellaneous
      t.boolean :has_results, default: false

      # Embedding for Semantic Search
      t.float :embedding, array: true, default: []  # Store embedding as a float array in PostgreSQL

      t.timestamps
    end
  end
end
