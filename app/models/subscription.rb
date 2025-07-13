class Subscription < ApplicationRecord
  belongs_to :client
  belongs_to :plan, optional: true
  belongs_to :package, optional: true

  has_many :subscription_additional_services, dependent: :destroy
  has_many :additional_services, through: :subscription_additional_services

  validate :plan_xor_package_present
  validate :no_duplicate_additional_services
  validate :no_service_conflict_with_package

  private
  def plan_xor_package_present
    if plan_id.present? && package_id.present?
      errors.add(:base, "Assinatura não pode ter plano e pacote ao mesmo tempo")
    elsif plan_id.blank? && package_id.blank?
      errors.add(:base, "Assinatura precisa ter plano ou pacote")
    end
  end

   def no_duplicate_additional_services
     if additional_services.length > additional_services.uniq.length
       errors.add(:base, "Assinatura não pode ter serviços adicionais duplicados")
     end
   end

    def no_service_conflict_with_package
      return if package.blank?

      conflicting_services = additional_services & package.additional_services
      if conflicting_services.any?
        names = conflicting_services.map(&:name).join(", ")
        errors.add(:base, "Assinatura não pode ter serviços adicionais que estejam no pacote: #{names}")
      end
    end
end
