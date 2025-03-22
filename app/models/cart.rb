class Cart < ApplicationRecord
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items

  after_update :calculate_final_price, if: :saved_change_to_discount?

  private

  def calculate_final_price
    self.final_price = total_price - discount
  end
end
