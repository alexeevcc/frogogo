require "test_helper"

class CartTest < ActiveSupport::TestCase
  test "should create cart with default values" do
    cart = Cart.create
    assert_equal 0.0, cart.total_price, "total_price should default to 0.0"
    assert_equal 0.0, cart.discount, "discount should default to 0.0"
    assert_equal 0.0, cart.final_price, "final_price should default to 0.0"

    assert cart.valid?, "Cart should be valid with default values"
  end

  test "should update final_price after discount update" do
    cart = Cart.create(total_price: 1000.00, discount: 100.00, final_price: 900)
    cart.update(discount: 200.00)
    assert_equal 800.00, cart.final_price
  end

  test "cart should be with secret_id" do
    cart = Cart.create
    assert cart.secret_id.present?, "secret_id should be present after creation with create"
  end
end
