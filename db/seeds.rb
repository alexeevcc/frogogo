Product.destroy_all
Cart.destroy_all
CartItem.destroy_all

goodyear_speaker = Product.create!(
  name: "Беспроводная колонка Goodyear Bluetooth Speaker",
  price: 1600.00,
  image: "goodyear_speaker.jpg"
)

sweet_dreams_suit = Product.create!(
  name: "Женский домашний костюм Sweet Dreams",
  price: 800.00,
  image: "sweet_dreams_suit.jpg"
)

swiss_oak_raincoat = Product.create!(
  name: "Плащ-дождевик SwissOak",
  price: 800.00,
  image: "swiss_oak_raincoat.jpg"
)

cart = Cart.create!(
  discount: 1000.00,
  total_price: 3200.00,
  final_price: 2200.00
)

CartItem.create!(
  cart: cart,
  product: goodyear_speaker,
  quantity: 1
)

CartItem.create!(
  cart: cart,
  product: sweet_dreams_suit,
  quantity: 1
)

CartItem.create!(
  cart: cart,
  product: swiss_oak_raincoat,
  quantity: 2
)

puts "Сиды успешно созданы!"
