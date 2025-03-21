require "test_helper"

class CartTest < ActiveSupport::TestCase
  test "should create cart with valid attributes" do
    cart = Cart.new
    assert cart.valid?
  end

  test "should update total_price after discount update" do
    cart = Cart.create(total_price: 1000.00, discount: 100.00)
    cart.update(discount: 200.00)
    assert_equal 800.00, cart.final_price
  end
end
