class Package < ApplicationRecord
  belongs_to :plan
  has_many :package_additional_services
  has_many :additional_services, through: :package_additional_services

  validates :name, presence: true
  validates :plan, presence: true
  validates :value, numericality: true, allow_nil: true

  validate  :must_have_at_least_one_service

  private
    def must_have_at_least_one_service
      if additional_services.empty?
        errors.add(:additional_services, "é preciso ter pelo menos um serviço adicional")
      end
    end
end
