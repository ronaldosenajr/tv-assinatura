class CreateBills < ActiveRecord::Migration[8.0]
  def change
    create_table :bills do |t|
      t.references :subscription, null: false, foreign_key: true
      t.string :item_type
      t.integer :item_id
      t.date :due_date
      t.decimal :value

      t.timestamps
    end
  end
end
