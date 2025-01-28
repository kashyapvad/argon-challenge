class ArmGroup < ApplicationRecord
    # Associations
    belongs_to :clinical_trial
    has_many :arm_group_interventions, dependent: :destroy
    has_many :interventions, through: :arm_group_interventions
  
    # Validations
    validates :label, presence: true
end
