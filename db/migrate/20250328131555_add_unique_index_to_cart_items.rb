class AddUniqueIndexToCartItems < ActiveRecord::Migration[8.0]
  def change
    add_index :cart_items, [:product_id, :cart_id], unique: true, name: 'index_cart_items_on_product_and_cart_unique'
  end
end
