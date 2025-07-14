class BookletSerializer < ActiveModel::Serializer
  attributes :id, :subscription_id, :total_value, :invoices

  def total_value
    object.invoices.sum(&:total_value)
  end

  def invoices
    object.invoices.order(:due_date).map do |invoice|
      {
        id: invoice.id,
        due_date: invoice.due_date,
        total_value: invoice.total_value,
        bills: invoice.bills_for_invoice.map do |bill|
          {
            id: bill.id,
            item_type: bill.item_type,
            item_id: bill.item_id,
            value: bill.value,
            due_date: bill.due_date
          }
        end
      }
    end
  end
end
