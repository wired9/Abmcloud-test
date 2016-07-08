class CreateSkus < ActiveRecord::Migration
  def change
    create_table :skus do |t|
      t.references :supplier, index: true
      t.float :price

      (1..6).each do |n|
        t.string "property_#{n}"
      end

      t.timestamps null: false
    end
  end
end
