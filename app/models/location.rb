class Location < ApplicationRecord
    # Associations
    belongs_to :clinical_trial

    # Validations
    validates :facility, presence: true
    validates :city, presence: true
    validates :country, presence: true
end
