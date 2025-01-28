class Outcome < ApplicationRecord
    # Associations
    belongs_to :clinical_trial

    # Validations
    validates :measure, presence: true
    validates :outcome_type, presence: true
end
