class PetApplication < ApplicationRecord
  belongs_to :pet
  belongs_to :application
  attribute :approval_status, :string, default: "Pending"
end
