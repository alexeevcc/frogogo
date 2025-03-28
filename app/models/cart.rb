class Cart < ApplicationRecord
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items

  before_validation :set_secret_id
  before_save :calculate_final_price

  validates :secret_id,   presence: true, uniqueness: true
  validates :total_price, numericality: { greater_than_or_equal_to: 0 }
  validates :discount,    numericality: { greater_than_or_equal_to: 0 }
  validate :final_price_non_negative

  def recalculate_totals
    new_total = cart_items.joins(:product).sum('products.price * cart_items.quantity')
    update_columns(
      total_price: new_total,
      final_price: [new_total - discount, 0].max
    )
  end

  private

  def set_secret_id
    self.secret_id ||= SecureRandom.uuid + DateTime.now.to_i.to_s
  end

  def calculate_final_price
    self.final_price = total_price - discount
  end

  def final_price_non_negative
    if discount > total_price
      errors.add(:discount, "cannot exceed total price")
    end
  end
end
