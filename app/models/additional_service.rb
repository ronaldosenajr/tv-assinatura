class AdditionalService < ApplicationRecord
  has_many :package_additional_services
  has_many :packages, through: :package_additional_services
  validates :name, presence: true
  validates :value, presence: true, numericality: true
end
