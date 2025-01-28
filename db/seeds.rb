# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
# (  ["Action", "Comedy", "Drama", "Horror"] || []).each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# db/seeds.rb

require 'json'
require 'openai'

# Initialize OpenAI client
#client = OpenAI::Client.new(access_token: ENV['OPEN_AI_API_KEY'])

# Path to the JSON file
file_path = Rails.root.join('db', 'ctg-studies.json')

# Read and parse the JSON data
json_data = File.read(file_path)
clinical_trials = JSON.parse(json_data)

(clinical_trials || []).each_with_index do |trial_data, index|
  puts "Processing Clinical Trial #{index + 1}/#{clinical_trials.size}..." 

  protocol_section = trial_data['protocolSection'] || {}

  # Identification Module
  identification = protocol_section['identificationModule'] || {}
  nct_id = identification['nctId']
  puts nct_id

  org_study_id = identification.dig('orgStudyIdInfo', 'id')
  sponsor_full_name = identification.dig('organization', 'fullName')
  sponsor_class = identification.dig('organization', 'class')
  brief_title = identification['briefTitle']
  official_title = identification['officialTitle']

  # Status Module
  status = protocol_section['statusModule'] || {}
  status_verified_date = status['statusVerifiedDate'] || ""
  status_verified_year = status_verified_date.split("-")[0].to_i
  status_verified_month = status_verified_date.split("-")[1].to_i
  overall_status = status['overallStatus']
  has_expanded_access = status.dig('expandedAccessInfo', 'hasExpandedAccess')
  start_date = status.dig('startDateStruct', 'date')
  start_date_parsed = 
  start_date_type = status.dig('startDateStruct', 'type')
  primary_completion_date = status.dig('primaryCompletionDateStruct', 'date')
  primary_completion_date_type = status.dig('primaryCompletionDateStruct', 'type')
  completion_date = status.dig('completionDateStruct', 'date')
  completion_date_type = status.dig('completionDateStruct', 'type')
  study_first_submit_date = status['studyFirstSubmitDate']
  study_first_submit_qc_date = status['studyFirstSubmitQcDate']
  study_first_post_date = status.dig('studyFirstPostDateStruct', 'date')
  study_first_post_date_type = status.dig('studyFirstPostDateStruct', 'type')
  last_update_submit_date = status['lastUpdateSubmitDate']
  last_update_post_date = status.dig('lastUpdatePostDateStruct', 'date')
  last_update_post_date_type = status.dig('lastUpdatePostDateStruct', 'type')

  # Sponsor Collaborators Module
  sponsor_collaborators = protocol_section['sponsorCollaboratorsModule'] || {}
  responsible_party_type = sponsor_collaborators.dig('responsibleParty', 'type')
  lead_sponsor_name = sponsor_collaborators.dig('leadSponsor', 'name')
  lead_sponsor_class = sponsor_collaborators.dig('leadSponsor', 'class')

  # Oversight Module
  oversight = protocol_section['oversightModule'] || {}
  is_fda_regulated_drug = oversight['isFdaRegulatedDrug']
  is_fda_regulated_device = oversight['isFdaRegulatedDevice']

  # Description Module
  description = protocol_section['descriptionModule'] || {}
  brief_summary = description['briefSummary']
  detailed_description = description['detailedDescription']

  # Conditions Module
  conditions = (protocol_section['conditionsModule'] || {})['conditions']
  # Split conditions by ';' if multiple conditions are concatenated
  conditions = (conditions || []).flat_map { |c| c.split(';').map(&:strip) }

  # Design Module
  design = protocol_section['designModule'] || {}
  study_type = design['studyType']
  phases = design['phases']
  allocation = design.dig('designInfo', 'allocation')
  intervention_model = design.dig('designInfo', 'interventionModel')
  intervention_model_description = design.dig('designInfo', 'interventionModelDescription')
  primary_purpose = design.dig('designInfo', 'primaryPurpose')
  masking = design.dig('designInfo', 'maskingInfo', 'masking')
  who_masked = design.dig('designInfo', 'maskingInfo', 'whoMasked') || []
  enrollment_count = design.dig('enrollmentInfo', 'count')
  enrollment_type = design.dig('enrollmentInfo', 'type')

  # Eligibility Module
  eligibility = protocol_section['eligibilityModule'] || {}
  eligibility_criteria = eligibility['eligibilityCriteria']
  healthy_volunteers = eligibility['healthyVolunteers']
  sex = eligibility['sex']
  minimum_age = eligibility['minimumAge']
  maximum_age = eligibility['maximumAge']
  std_ages = eligibility['stdAges'] || []

  # Derived Section
  derived_section = trial_data['derivedSection'] || {}
  misc_info = derived_section['miscInfoModule']
  version_holder = misc_info['versionHolder']
  intervention_browse = derived_section['interventionBrowseModule']

  # Arm Groups and Interventions
  arms_interventions = protocol_section['armsInterventionsModule'] || {}
  arm_groups_data = arms_interventions['armGroups']
  interventions_data = arms_interventions['interventions']

  # Outcomes Module
  outcomes_module = protocol_section['outcomesModule'] || {}
  primary_outcomes = outcomes_module['primaryOutcomes']

  # Contacts Locations Module
  contacts_locations = protocol_section['contactsLocationsModule'] || {}
  locations_data = contacts_locations['locations'] || {}

  status_verified_date_parsed = nil
  start_date_parsed = nil
  primary_completion_date_parsed = nil
  completion_date_parsed = nil
  study_first_submit_date_parsed = nil
  study_first_submit_qc_date_parsed = nil
  study_first_post_date_parsed = nil
  last_update_submit_date_parsed = nil
  last_update_post_date_parsed = nil
  status_verified_date_parsed = nil

  begin
    status_verified_date_parsed = Date.new(status_verified_year, status_verified_month)
    start_date_parsed = Date.parse(start_date)
    primary_completion_date_parsed = Date.parse(primary_completion_date)
    completion_date_parsed = Date.parse(completion_date)
    study_first_submit_date_parsed = Date.parse(study_first_submit_date)
    study_first_submit_qc_date_parsed = Date.parse(study_first_submit_qc_date)
    study_first_post_date_parsed = Date.parse(study_first_post_date)
    last_update_submit_date_parsed = Date.parse(last_update_submit_date)
    last_update_post_date_parsed = Date.parse(last_update_post_date)
  rescue
  end

  # Create ClinicalTrial Record
  clinical_trial = ClinicalTrial.find_or_initialize_by(nct_id: nct_id)
  clinical_trial.assign_attributes(
    org_study_id: org_study_id,
    sponsor_full_name: sponsor_full_name,
    sponsor_class: sponsor_class,
    brief_title: brief_title,
    official_title: official_title,
    status_verified_date: status_verified_date_parsed,
    overall_status: overall_status,
    has_expanded_access: has_expanded_access,
    start_date: start_date_parsed,
    start_date_type: start_date_type,
    primary_completion_date: primary_completion_date_parsed,
    primary_completion_date_type: primary_completion_date_type,
    completion_date: completion_date_parsed,
    completion_date_type: completion_date_type,
    study_first_submit_date: study_first_submit_date_parsed,
    study_first_submit_qc_date: study_first_submit_qc_date_parsed,
    study_first_post_date: study_first_post_date_parsed,
    study_first_post_date_type: study_first_post_date_type,
    last_update_submit_date: last_update_submit_date_parsed,
    last_update_post_date: last_update_post_date_parsed,
    last_update_post_date_type: last_update_post_date_type,
    responsible_party_type: responsible_party_type,
    lead_sponsor_name: lead_sponsor_name,
    lead_sponsor_class: lead_sponsor_class,
    is_fda_regulated_drug: is_fda_regulated_drug,
    is_fda_regulated_device: is_fda_regulated_device,
    brief_summary: brief_summary,
    detailed_description: detailed_description,
    conditions: conditions,
    study_type: study_type,
    phases: phases,
    allocation: allocation,
    intervention_model: intervention_model,
    intervention_model_description: intervention_model_description,
    primary_purpose: primary_purpose,
    masking: masking,
    who_masked: who_masked,
    enrollment_count: enrollment_count,
    enrollment_type: enrollment_type,
    eligibility_criteria: eligibility_criteria,
    healthy_volunteers: healthy_volunteers,
    sex: sex,
    minimum_age: minimum_age,
    maximum_age: maximum_age,
    std_ages: std_ages,
    version_holder: version_holder,
    has_results: trial_data['hasResults']
  )

  clinical_trial.save!

  # Generate and Assign Embedding
  # combined_text = [
  #   nct_id,
  #   org_study_id,
  #   sponsor_full_name,
  #   sponsor_class,
  #   brief_title,
  #   official_title,
  #   overall_status,
  #   brief_summary,
  #   detailed_description,
  #   conditions.join(' '),
  #   phases.join(' '),
  #   allocation,
  #   intervention_model,
  #   intervention_model_description,
  #   primary_purpose,
  #   masking,
  #   who_masked.join(' '),
  #   enrollment_count.to_s,
  #   enrollment_type,
  #   eligibility_criteria,
  #   healthy_volunteers.to_s,
  #   sex,
  #   minimum_age,
  #   maximum_age,
  #   std_ages.join(' '),
  #   version_holder
  # ].compact.join(' ')

  # begin
  #   response = client.embeddings(
  #     parameters: {
  #       model: "text-embedding-ada-002",
  #       input: combined_text
  #     }
  #   )
  #   embedding = response['data'][0]['embedding']
  #   clinical_trial.embedding = embedding
  # rescue OpenAI::Error => e
  #   puts "OpenAI API Error for trial #{nct_id}: #{e.message}"
  #   next
  # rescue => e
  #   puts "Unexpected Error for trial #{nct_id}: #{e.message}"
  #   next
  # end

  # # Save ClinicalTrial Record
  # if clinical_trial.save
  #   puts "Saved Clinical Trial: #{nct_id}"
  # else
  #   puts "Failed to save Clinical Trial: #{nct_id}"
  #   next
  # end

  # Process Arm Groups and Interventions
  (arm_groups_data || []).each do |arm_data|
    arm_group = ArmGroup.find_or_initialize_by(
      clinical_trial: clinical_trial,
      label: arm_data['label']
    )
    arm_group.assign_attributes(
      arm_type: arm_data['type'],
      description: arm_data['description']
    )
    arm_group.save!

    # Process Interventions for each ArmGroup
    (arm_data['interventionNames'] || []).each do |intervention_name|
      # Extract the actual intervention name after "Drug: "
      intervention_actual_name = intervention_name.split(': ').last

      # Find or create the Intervention
      intervention = Intervention.find_or_create_by(
        name: intervention_actual_name
      ) do |interv|
        # Assign other attributes if necessary
        interv.description = 'No description provided' # Placeholder
        interv.intervention_type = 'DRUG' # Assuming all interventions are drugs
      end

      # Associate Intervention with ArmGroup
      arm_group.interventions << intervention unless arm_group.interventions.include?(intervention)
    end
  end 

  # Process Interventions Module (Optional: Additional Interventions)
  (interventions_data || []).each do |interv_data|
    intervention = Intervention.find_or_initialize_by(name: interv_data['name'])
    intervention.assign_attributes(
      description: interv_data['description'],
      intervention_type: interv_data['type']
    )
    intervention.save!

    # Associate with ArmGroups
    (interv_data['armGroupLabels'] || []).each do |arm_label|
      arm_group = ArmGroup.find_by(clinical_trial: clinical_trial, label: arm_label)
      if arm_group
        arm_group.interventions << intervention unless arm_group.interventions.include?(intervention)
      else
        puts "Arm Group with label '#{arm_label}' not found for trial #{nct_id}"
      end
    end
  end

  # Process Outcomes
  (primary_outcomes || []).each do |outcome_data|
    outcome = Outcome.find_or_initialize_by(
      clinical_trial: clinical_trial,
      measure: outcome_data['measure'],
      outcome_type: 'Primary'
    )
    outcome.assign_attributes(
      description: outcome_data['description'],
      time_frame: outcome_data['timeFrame']
    )
    outcome.save!
  end

  # Process Locations
  (locations_data || []).each do |location_data|
    location = Location.find_or_initialize_by(
      clinical_trial: clinical_trial,
      facility: location_data['facility'],
      city: location_data['city'],
      country: location_data['country']
    )
    location.assign_attributes(
      latitude: location_data.dig('geoPoint', 'lat'),
      longitude: location_data.dig('geoPoint', 'lon')
    )
    location.save!
  end
end

puts "Seeding completed. Total Clinical Trials: #{ClinicalTrial.count}"