class Package < ApplicationRecord
  belongs_to :plan
  has_many :package_additional_services, dependent: :destroy
  has_many :subscriptions, dependent: :nullify
  has_many :additional_services, through: :package_additional_services

  validates :name, presence: true
  validates :plan, presence: true
  validates :value, numericality: true, allow_nil: true

  validate  :must_have_at_least_one_service
  before_validation :set_value


  private
    def must_have_at_least_one_service
      if additional_services.empty?
        errors.add(:additional_services, "é preciso ter pelo menos um serviço adicional")
      end
    end

    def set_value
      return if value.present?
      return unless plan.present?  # só calcula se plan existir
      return if additional_services.blank?  # não calcula se não houver serviços adicionais
      total = plan.value.to_f + additional_services.sum(&:value)
      self.value = total
    end
end
