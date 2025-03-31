# t.integer "cart_id", null: false
# t.integer "product_id", null: false
# t.integer "quantity", default: 1, null: false
# t.datetime "created_at", null: false
# t.datetime "updated_at", null: false
# t.index ["cart_id", "product_id"], name: "index_cart_items_on_cart_id_and_product_id", unique: true
# t.index ["cart_id"], name: "index_cart_items_on_cart_id"
# t.index ["product_id"], name: "index_cart_items_on_product_id"
class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product

  after_commit :update_cart_totals, on: [:create, :update, :destroy]

  validates :cart_id, :product_id, :quantity, presence: true
  validates :product_id, uniqueness: { scope: :cart_id }
  validates :quantity, numericality: { only_integer: true, greater_than: 0 }

  private

  def update_cart_totals
    return if destroyed_by_association

    cart.recalculate_totals if cart&.persisted?
  end
end
