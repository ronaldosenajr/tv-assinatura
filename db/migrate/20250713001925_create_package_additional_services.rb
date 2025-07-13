class CreatePackageAdditionalServices < ActiveRecord::Migration[8.0]
  def change
    create_table :package_additional_services do |t|
      t.references :package, null: false, foreign_key: true
      t.string :additional_services
      t.string :references

      t.timestamps
    end
  end
end
