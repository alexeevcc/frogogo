class Product < ApplicationRecord
  has_many :cart_items

  validates :name, :price, presence: true
end
