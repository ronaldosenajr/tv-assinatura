class Package < ApplicationRecord
  belongs_to :plan
  has_many :package_additional_services
  has_many :additional_services, through: :package_additional_services

  validates :name, presence: true
  validates :plan, presence: true
  validates :value, numericality: true, allow_nil: true
end
