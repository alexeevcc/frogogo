require "test_helper"

class CartTest < ActiveSupport::TestCase
  setup do
    @product = create(:product, price: 100.00)
    @cart = create(:cart)
  end

  test "should set secret_id before validation" do
    cart = build(:cart, secret_id: nil)
    assert cart.valid?
    assert_not_nil cart.secret_id
    assert_match /\A[a-f0-9\-]+\d{10}\z/, cart.secret_id
  end

  test "should validate numericality of prices" do
    invalid_cart = build(:cart, total_price: "invalid", discount: "invalid")
    assert_not invalid_cart.valid?
    assert_includes invalid_cart.errors[:total_price], "is not a number"
    assert_includes invalid_cart.errors[:discount], "is not a number"
  end

  test "should validate prices are greater than or equal to 0" do
    invalid_cart = build(:cart, total_price: -1, discount: -1)
    assert_not invalid_cart.valid?
    assert_includes invalid_cart.errors[:total_price], "must be greater than or equal to 0"
    assert_includes invalid_cart.errors[:discount], "must be greater than or equal to 0"
  end

  test "should recalculate totals when cart_items change" do
    cart = create(:cart)
    assert_difference 'cart.reload.total_price', 100.00 do
      create(:cart_item, cart: cart, product: @product, quantity: 1)
    end
    assert_equal 100.00.to_d, cart.final_price
  end

  test "should update totals when cart_item quantity changes" do
    item = create(:cart_item, cart: @cart, product: @product, quantity: 1)
    assert_difference '@cart.reload.total_price', 100.00 do
      item.update!(quantity: 2)
    end
  end

  test "should update totals when cart_item is destroyed" do
    item = create(:cart_item, cart: @cart, product: @product, quantity: 2)
    assert_difference '@cart.reload.total_price', -200.00 do
      item.destroy!
    end
  end

  # 3. Тесты ассоциаций
  test "should have cart_items association" do
    assert_respond_to @cart, :cart_items
    assert_empty @cart.cart_items

    create(:cart_item, cart: @cart)
    assert_not_empty @cart.reload.cart_items
  end

  test "should have products through cart_items" do
    assert_respond_to @cart, :products
    create(:cart_item, cart: @cart, product: @product)
    assert_includes @cart.products, @product
  end

  test "should destroy associated cart_items when destroyed" do
    item = create(:cart_item, cart: @cart)

    assert_difference('CartItem.count', -1) do
      @cart.destroy!
    end

    assert_raises(ActiveRecord::RecordNotFound) { item.reload }
  end

  test "should handle zero discount correctly" do
    cart = create(:cart, total_price: 500.00, discount: 0.00)
    assert_equal 500.00.to_d, cart.final_price
  end

  test "should not allow discount greater than total_price" do
    cart = build(:cart, total_price: 100.00, discount: 200.00)
    assert_not cart.valid?
    assert_includes cart.errors[:discount], "cannot exceed total price"
  end

  test "factory with_items should create cart with items" do
    cart = create(:cart, :with_items, items_count: 2)
    assert_equal 2, cart.cart_items.count
    assert_equal 2, cart.products.count
    assert_equal 200.00.to_d, cart.total_price
  end
end
