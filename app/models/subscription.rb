class Subscription < ApplicationRecord
  belongs_to :client
  belongs_to :plan, optional: true
  belongs_to :package, optional: true

has_many :subscription_additional_services, dependent: :destroy, after_add: :after_additional_service_changed, after_remove: :after_additional_service_changed
  has_many :additional_services, through: :subscription_additional_services
  has_many :bills, dependent: :destroy
  has_many :invoices, dependent: :destroy
  has_one :booklet, dependent: :destroy

  after_create :generate_billing
  after_update :regenerate_billing_if_needed

  validate :plan_xor_package_present
  validate :client_cannot_have_conflicting_subscriptions, on: :create

  validate :no_duplicate_additional_services
  validate :no_service_conflict_with_package

  def after_additional_service_changed(_service)
    regenerate_billing! if persisted?
  end

  def regenerate_billing_if_needed
    if saved_change_to_plan_id? || saved_change_to_package_id?
      regenerate_billing!
    end
  end

  def regenerate_billing!
    bills.destroy_all
    invoices.destroy_all
    booklet&.destroy
    generate_billing
  end

  def generate_billing
    today = Time.zone.today
    due_day = today.day
    start_date = today.next_month.change(day: [ due_day, 28 ].min) # evita dia 31

    12.times do |i|
      due_date = start_date.advance(months: i)
      monthly_bills = []

      # Conta do plano ou pacote
      if plan.present?
        monthly_bills << bills.create!(
          item: plan,
          due_date: due_date,
          value: plan.value
        )
      elsif package.present?
        monthly_bills << bills.create!(
          item: package,
          due_date: due_date,
          value: package.value
        )
      end

      # Contas dos serviços adicionais
      additional_services.each do |service|
        monthly_bills << bills.create!(
          item: service,
          due_date: due_date,
          value: service.value
        )
      end

      # Fatura do mês (agrupamento das contas)
      invoices.create!(
        due_date: due_date,
        total_value: monthly_bills.sum(&:value)
      )
    end

    # Carnê
    create_booklet!
  end

  def cancel_subscription
    date = Time.zone.today
    bills.where("due_date >= ?", date).find_each do |bill|
      bill.update!(value: 0)
    end
    invoices.where("due_date >= ?", date).find_each do |invoice|
      invoice.update!(total_value: 0)
    end
  end

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

  def client_cannot_have_conflicting_subscriptions
    return unless client

    # Se for assinatura com plano
    if plan.present?
      # verifica se cliente tem assinatura com pacote
      if Subscription.where(client: client).where.not(id: id).where.not(package_id: nil).exists?
        errors.add(:base, "Cliente já tem assinatura com pacote. Não pode assinar plano simultaneamente")
      end
    end

    # Se for assinatura com pacote
    if package.present?
      # verifica se cliente tem assinatura com plano
      if Subscription.where(client: client).where.not(id: id).where.not(plan_id: nil).exists?
        errors.add(:base, "Cliente já tem assinatura com plano. Não pode assinar pacote simultaneamente")
      end
    end
  end
end
