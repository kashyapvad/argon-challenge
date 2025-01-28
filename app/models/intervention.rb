class Intervention < ApplicationRecord
    # Associations
    has_many :arm_group_interventions, dependent: :destroy
    has_many :arm_groups, through: :arm_group_interventions
end
