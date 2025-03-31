require "test_helper"

# test/cart_test.rb
class CartTest < ActiveSupport::TestCase
  setup do
    @product = create(:product)
    @cart = create(:cart)
  end

  # === Associations ===

  test "should destroy associated cart_items when destroyed" do
    item = create(:cart_item, cart: @cart)

    assert_difference('CartItem.count', -1) do
      @cart.destroy!
    end

    assert_raises(ActiveRecord::RecordNotFound) { item.reload }
  end

  # === Callbacks ===

  test "does not regenerate UUID on update" do
    original_uuid = @cart.uuid
    @cart.update!(total_price: 100.0)
    assert_equal original_uuid, @cart.reload.uuid
  end

  test "should set uuid before validation" do
    cart = build(:cart, uuid: nil)
    assert cart.valid?
    assert_not_nil cart.uuid
    assert_match /\A[a-f0-9\-]+\d{10}\z/, cart.uuid
  end

  test "calculates final_price before save" do
    @cart.total_price = 300.0
    @cart.discount = 50.0
    @cart.save!
    assert_equal 250.0.to_d, @cart.final_price
  end

  # === Validations ===

  test "should validate numericality of prices" do
    invalid_cart = build(:cart, total_price: "invalid", discount: "invalid", final_price: "invalid")
    assert_not invalid_cart.valid?
    assert_includes invalid_cart.errors[:total_price], "не является числом"
    assert_includes invalid_cart.errors[:discount], "не является числом"
    assert_includes invalid_cart.errors[:final_price], "не является числом"
  end

  test "should validate prices are greater than or equal to 0" do
    invalid_cart = build(:cart, total_price: -1, discount: -1)
    assert_not invalid_cart.valid?
    assert_includes invalid_cart.errors[:total_price], "может иметь значение большее или равное 0"
    assert_includes invalid_cart.errors[:discount], "может иметь значение большее или равное 0"
  end

  test "should not allow discount greater than total_price" do
    cart = build(:cart, total_price: 100.00, discount: 200.00)
    assert_not cart.valid?
    assert_includes cart.errors[:discount], "может иметь значение меньшее или равное 100.0"
  end

  test "allows discount equal to total_price" do
    @cart.total_price = 200.0
    @cart.discount = 200.0
    assert @cart.valid?
  end

  test "rounds total_price to 2 decimal places" do
    @cart.total_price = 123.456
    @cart.save!
    assert_equal 123.46.to_d, @cart.reload.total_price
  end

  test "final_price never negative" do
    @cart.update_columns(total_price: 100.0, discount: 150.0)
    assert_equal 0.0.to_d, @cart.final_price
  end

  # === Business Logic ===

  test "recalculate_totals updates prices based on items" do
    create(:cart_item, cart: @cart, product: @product, quantity: 2)

    @cart.recalculate_totals

    assert_equal (@product.price * 2).to_d, @cart.total_price
    assert_equal (@product.price * 2).to_d, @cart.final_price
  end

  test "recalculate_totals respects discount" do
    create(:cart_item, cart: @cart, product: @product, quantity: 2)
    @cart.update!(discount: 50.0)

    @cart.recalculate_totals

    assert_equal (@product.price * 2).to_d, @cart.total_price
    assert_equal (@product.price * 2 - 50).to_d, @cart.final_price
  end

  test "clear removes all cart_items" do
    create_list(:cart_item, 3, cart: @cart)
    assert_difference("CartItem.count", -3) do
      @cart.clear
    end
  end

  test "clear resets all prices to zero" do
    @cart.update!(total_price: 500.0, discount: 100.0, final_price: 400.0)
    @cart.clear
    assert_equal 0.0.to_d, @cart.total_price
    assert_equal 0.0.to_d, @cart.discount
    assert_equal 0.0.to_d, @cart.final_price
  end
end
