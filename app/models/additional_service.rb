class AdditionalService < ApplicationRecord
  has_many :package_additional_services, dependent: :destroy
  has_many :subscription_additional_services, dependent: :destroy
  has_many :packages, through: :package_additional_services
  has_many :subscriptions, through: :subscription_additional_services

  validates :name, presence: true
  validates :value, presence: true, numericality: true
end
