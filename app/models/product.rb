class Product < ApplicationRecord
  has_many :cart_items, dependent: :destroy

  has_one_attached :image

  validates :name, :price, presence: true
  validates :price, numericality: { greater_than: 0 }
  validates :image,
            content_type: ['image/png', 'image/jpeg', 'image/webp'],
            size: { less_than: 5.megabytes }
end
