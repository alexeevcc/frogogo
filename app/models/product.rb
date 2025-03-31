# t.string "image"
# t.string "name", null: false
# t.decimal "price", precision: 10, scale: 2, null: false
# t.datetime "created_at", null: false
# t.datetime "updated_at", null: false

class Product < ApplicationRecord
  has_many :cart_items, dependent: :destroy

  has_one_attached :image

  validates :name, :price, presence: true
  validates :price, numericality: { greater_than: 0 }
  validates :image,
            content_type: ['image/png', 'image/jpeg', 'image/webp'],
            size: { less_than: 5.megabytes }
end
