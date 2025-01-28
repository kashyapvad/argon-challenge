class ClinicalTrial < ApplicationRecord
  # Associations
  has_many :arm_groups, dependent: :destroy
  has_many :arm_group_interventions, through: :arm_groups
  has_many :interventions, through: :arm_group_interventions
  has_many :outcomes, dependent: :destroy
  has_many :locations, dependent: :destroy
end
