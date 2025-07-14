class Booklet < ApplicationRecord
  belongs_to :subscription
  has_many :invoices, through: :subscription

  def total_value
    invoices.sum(&:total_value)
  end

  # Retorna um hash com ano-mês como chave e soma dos valores como valor
  def monthly_totals
    invoices.group_by { |inv| inv.due_date.strftime("%Y-%m-%d") }
            .transform_values { |invoices| invoices.sum(&:total_value) }
  end

  def monthly_totals_array
    monthly_totals.map do |month, total|
      { end_date: month, total_value: total }
    end
  end
end
