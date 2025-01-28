class ArmGroupIntervention < ApplicationRecord
  # Associations
  belongs_to :arm_group
  belongs_to :intervention

  # Validations
  validates :arm_group_id, presence: true
  validates :intervention_id, presence: true
end
