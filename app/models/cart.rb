# Entity of Cart
# t.decimal "discount", precision: 10, scale: 2, default: "0.0"
# t.decimal "total_price", precision: 10, scale: 2, default: "0.0"
# t.decimal "final_price", precision: 10, scale: 2, default: "0.0"
# t.string "uuid", null: false
# t.datetime "created_at", null: false
# t.datetime "updated_at", null: false
# t.index ["uuid"], name: "index_carts_on_uuid", unique: true

class Cart < ApplicationRecord
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items

  before_validation :generate_uuid, on: :create

  validates :uuid, presence: true, uniqueness: true
  validates :total_price, :discount, :final_price,
            presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates_comparison_of :discount, less_than_or_equal_to: :total_price

  before_save :calculate_final_price

  def recalculate_totals
    new_total = cart_items.joins(:product).sum("products.price * cart_items.quantity")
    update_columns(
      total_price: new_total,
      final_price: [new_total - discount, 0].max
    )
  end

  def clear
    self.transaction do
      cart_items.delete_all
      update_columns(final_price: 0, total_price: 0, discount: 0)
    end
  end

  private

  def generate_uuid
    self.uuid ||= SecureRandom.uuid + DateTime.now.to_i.to_s
  end

  def calculate_final_price
    self.final_price = total_price - discount
  end
end
