class CreatePackages < ActiveRecord::Migration[8.0]
  def change
    create_table :packages do |t|
      t.string :name
      t.decimal :value
      t.references :plan, null: false, foreign_key: true

      t.timestamps
    end
  end
end
