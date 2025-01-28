# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2025_01_27_230948) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "vector"

  create_table "arm_group_interventions", force: :cascade do |t|
    t.bigint "arm_group_id", null: false
    t.bigint "intervention_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["arm_group_id"], name: "index_arm_group_interventions_on_arm_group_id"
    t.index ["intervention_id"], name: "index_arm_group_interventions_on_intervention_id"
  end

  create_table "arm_groups", force: :cascade do |t|
    t.bigint "clinical_trial_id", null: false
    t.string "label"
    t.string "arm_type"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["clinical_trial_id"], name: "index_arm_groups_on_clinical_trial_id"
  end

  create_table "clinical_trials", force: :cascade do |t|
    t.string "nct_id", null: false
    t.string "org_study_id"
    t.string "sponsor_full_name"
    t.string "sponsor_class"
    t.string "brief_title"
    t.string "official_title"
    t.date "status_verified_date"
    t.string "overall_status"
    t.boolean "has_expanded_access"
    t.date "start_date"
    t.string "start_date_type"
    t.date "primary_completion_date"
    t.string "primary_completion_date_type"
    t.date "completion_date"
    t.string "completion_date_type"
    t.date "study_first_submit_date"
    t.date "study_first_submit_qc_date"
    t.date "study_first_post_date"
    t.string "study_first_post_date_type"
    t.date "last_update_submit_date"
    t.date "last_update_post_date"
    t.string "last_update_post_date_type"
    t.string "responsible_party_type"
    t.string "lead_sponsor_name"
    t.string "lead_sponsor_class"
    t.boolean "is_fda_regulated_drug"
    t.boolean "is_fda_regulated_device"
    t.text "brief_summary"
    t.text "detailed_description"
    t.text "conditions", default: [], array: true
    t.string "study_type"
    t.string "phases", default: [], array: true
    t.string "allocation"
    t.string "intervention_model"
    t.text "intervention_model_description"
    t.string "primary_purpose"
    t.string "masking"
    t.string "who_masked", default: [], array: true
    t.integer "enrollment_count"
    t.string "enrollment_type"
    t.text "eligibility_criteria"
    t.boolean "healthy_volunteers"
    t.string "sex"
    t.string "minimum_age"
    t.string "maximum_age"
    t.string "std_ages", default: [], array: true
    t.string "version_holder"
    t.boolean "has_results", default: false
    t.float "embedding", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "interventions", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "intervention_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "locations", force: :cascade do |t|
    t.bigint "clinical_trial_id", null: false
    t.string "facility"
    t.string "city"
    t.string "country"
    t.float "latitude"
    t.float "longitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["clinical_trial_id"], name: "index_locations_on_clinical_trial_id"
  end

  create_table "outcomes", force: :cascade do |t|
    t.bigint "clinical_trial_id", null: false
    t.string "measure"
    t.text "description"
    t.string "time_frame"
    t.string "outcome_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["clinical_trial_id"], name: "index_outcomes_on_clinical_trial_id"
  end

  add_foreign_key "arm_group_interventions", "arm_groups"
  add_foreign_key "arm_group_interventions", "interventions"
  add_foreign_key "arm_groups", "clinical_trials"
  add_foreign_key "locations", "clinical_trials"
  add_foreign_key "outcomes", "clinical_trials"
end
