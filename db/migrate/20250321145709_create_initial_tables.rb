class CreateInitialTables < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :image
      t.string :name, null: false
      t.decimal :price, precision: 10, scale: 2, null: false

      t.timestamps
    end

    create_table :carts do |t|
      t.decimal :discount, precision: 10, scale: 2, default: 0.0
      t.decimal :total_price, precision: 10, scale: 2, default: 0.0
      t.decimal :final_price, precision: 10, scale: 2, default: 0.0

      t.timestamps
    end

    create_table :cart_items do |t|
      t.bigint :cart_id, null: false
      t.bigint :product_id, null: false
      t.integer :quantity, default: 1, null: false

      t.timestamps
    end

    add_index :cart_items, :cart_id
    add_index :cart_items, :product_id
    add_foreign_key :cart_items, :carts
    add_foreign_key :cart_items, :products
  end
end
