class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product

  after_commit :update_cart_totals, on: [:create, :update, :destroy]

  validates :quantity, :product_id, presence: true
  validates :product_id, uniqueness: { scope: :cart_id }
  validates :quantity, numericality: { only_integer: true, greater_than: 0 }

  private

  def update_cart_totals
    return if destroyed_by_association

    cart.recalculate_totals if cart&.persisted?
  end
end
