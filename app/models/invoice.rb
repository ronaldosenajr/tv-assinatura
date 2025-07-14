class Invoice < ApplicationRecord
  belongs_to :subscription

  def bills_for_invoice
    Bill.where(subscription_id: subscription_id, due_date: due_date)
  end

  def total_value
    bills_for_invoice.sum(:value)
  end
end
