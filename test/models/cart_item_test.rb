require "test_helper"

# test/cart_item_test.rb
class CartItemTest < ActiveSupport::TestCase
  setup do
    @product = create(:product)
    @cart = create(:cart)
  end

  # === Associations ===

  test "should have correct associations" do
    assert_equal :belongs_to, CartItem.reflect_on_association(:cart).macro
    assert_equal :belongs_to, CartItem.reflect_on_association(:product).macro
  end

  # === Validations ===

  test "invalid without cart" do
    item = build(:cart_item, cart: nil, product: @product)
    assert_not item.valid?
    assert_equal ["не может отсутствовать"], item.errors[:cart]
  end

  test "invalid without product" do
    item = build(:cart_item, cart: @cart, product: nil)
    assert_not item.valid?
    assert_equal ["не может отсутствовать"], item.errors[:product]
  end

  test "should have correct default quantity" do
    item = CartItem.new
    assert_equal 1, item.quantity
  end

  test "valid with correct attributes" do
    item = build(:cart_item, cart: @cart, product: @product)
    assert item.valid?
  end

  test "invalid with non-positive quantity" do
    item = build(:cart_item, quantity: 0)
    assert_not item.valid?
    assert_includes item.errors[:quantity], "может иметь значение большее 0"
  end

  test "invalid with non-integer quantity" do
    item = build(:cart_item, quantity: 1.5)
    assert_not item.valid?
    assert_includes item.errors[:quantity], "не является целым числом"
  end

  test "does not allow duplicate products in same cart" do
    create(:cart_item, cart: @cart, product: @product)
    duplicate_item = build(:cart_item, cart: @cart, product: @product)

    assert_not duplicate_item.valid?
    assert_equal ["уже существует"], duplicate_item.errors[:product_id]
  end

  test "allows same product in different carts" do
    create(:cart_item, cart: @cart, product: @product)
    new_cart = create(:cart)
    item_in_new_cart = build(:cart_item, cart: new_cart, product: @product)

    assert item_in_new_cart.valid?
  end

  test "should enforce uniqueness at database level" do
    create(:cart_item, cart: @cart, product: @product)
    duplicate = CartItem.new(cart: @cart, product: @product, quantity: 1)

    exception = assert_raises(ActiveRecord::RecordInvalid) do
      duplicate.save!
    end

    assert_match /Возникли ошибки: Product уже существует/, exception.message
  end

  test "should have proper unique index in database" do
    indexes = ActiveRecord::Base.connection.indexes(:cart_items)
    assert indexes.any? { |i| i.columns == ["cart_id", "product_id"] && i.unique }
  end

  # === Callbacks ===

  test "should trigger cart totals recalculation on create" do
    assert_difference '@cart.reload.total_price', @product.price do
      create(:cart_item, cart: @cart, product: @product, quantity: 1)
    end

    assert_equal @product.price.to_d, @cart.final_price
  end

  test "should trigger cart totals recalculation on quantity update" do
    item = create(:cart_item, cart: @cart, product: @product, quantity: 1)
    assert_difference '@cart.reload.total_price', @product.price do
      item.update!(quantity: 2)
    end
  end

  test "should update totals when cart_item is destroyed" do
    item = create(:cart_item, cart: @cart, product: @product, quantity: 2)
    assert_difference '@cart.reload.total_price', -(@product.price * 2) do
      item.destroy!
    end
  end
end
