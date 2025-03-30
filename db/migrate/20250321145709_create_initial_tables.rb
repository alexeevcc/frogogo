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
      t.string :uuid, null: false

      t.timestamps
    end

    create_table :cart_items do |t|
      t.references :cart, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.integer :quantity, default: 1, null: false

      t.timestamps
    end

    add_index :carts, :uuid, unique: true
    add_index :cart_items, [:cart_id, :product_id], unique: true
  end
end
