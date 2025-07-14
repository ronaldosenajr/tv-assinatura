class CreateInvoices < ActiveRecord::Migration[8.0]
  def change
    create_table :invoices do |t|
      t.references :subscription, null: false, foreign_key: true
      t.date :due_date
      t.decimal :total_value

      t.timestamps
    end
  end
end
