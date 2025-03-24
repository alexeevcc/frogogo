class Cart < ApplicationRecord
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items

  before_validation :set_secret_id
  after_update :calculate_final_price, if: :saved_change_to_discount?

  validates :secret_id,   presence: true, uniqueness: true
  validates :total_price, numericality: { greater_than_or_equal_to: 0 }
  validates :discount,    numericality: { greater_than_or_equal_to: 0 }
  validates :final_price, numericality: { greater_than_or_equal_to: 0 }

  private

  def set_secret_id
    self.secret_id = SecureRandom.uuid + DateTime.now.to_i.to_s
  end

  def calculate_final_price
    self.final_price = total_price - discount
  end
end
