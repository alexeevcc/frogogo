Product.destroy_all
Cart.destroy_all
CartItem.destroy_all

products = [
  {
    name: "Беспроводная колонка Goodyear Bluetooth Speaker",
    price: 1600.00,
    image_path: Rails.root.join("app/assets/images/product-1.jpg")
  },
  {
    name: "Женский домашний костюм Sweet Dreams",
    price: 800.00,
    image_path: Rails.root.join("app/assets/images/product-2.jpg")
  },
  {
    name: "Плащ-дождевик SwissOak",
    price: 800.00,
    image_path: Rails.root.join("app/assets/images/product-3.jpg")
  }
]

products.each do |product_data|
  product = Product.create(
    name: product_data[:name],
    price: product_data[:price]
  )

  product.image.attach(
    io: File.open(product_data[:image_path]),
    filename: File.basename(product_data[:image_path]),
    content_type: 'image/png'
  )
end

puts "Сиды успешно созданы!"
