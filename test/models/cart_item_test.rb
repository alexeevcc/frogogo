require "test_helper"

class CartItemTest < ActiveSupport::TestCase
  test "should create cart_item with valid attributes" do
    product = Product.create(name: "Беспроводная колонка", price: 1600.00)
    cart = Cart.create
    cart_item = CartItem.new(cart:, product:, quantity: 1)
    assert cart_item.valid?
  end

  test "should not create cart_item without cart" do
    product = Product.create(name: "Беспроводная колонка", price: 1600.00)
    cart_item = CartItem.new(product:, quantity: 1)
    assert_not cart_item.valid?
    assert_equal ["не может быть пустым"], cart_item.errors[:cart]
  end

  test "should not create cart_item without product" do
    cart = Cart.create
    cart_item = CartItem.new(cart:, quantity: 1)
    assert_not cart_item.valid?
    assert_equal ["не может быть пустым"], cart_item.errors[:product]
  end
end
