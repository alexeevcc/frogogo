class Product < ApplicationRecord
  has_many :cart_items

  has_one_attached :image

  validates :name, :price, presence: true
end
