require "test_helper"

class CartItemTest < ActiveSupport::TestCase
  setup do
    @product = create(:product, name: "Беспроводная колонка", price: 1600.00)
    @cart = create(:cart)
  end

  test "should have correct database columns" do
    assert_equal ["cart_id", "created_at", "id", "product_id", "quantity", "updated_at"],
                 CartItem.column_names.sort
  end

  test "should have correct associations" do
    assert_equal :belongs_to, CartItem.reflect_on_association(:cart).macro
    assert_equal :belongs_to, CartItem.reflect_on_association(:product).macro
  end

  test "should have correct default quantity" do
    item = CartItem.new
    assert_equal 1, item.quantity
  end

  test "valid with correct attributes" do
    item = build(:cart_item, cart: @cart, product: @product)
    assert item.valid?
  end

  test "invalid without cart" do
    item = build(:cart_item, cart: nil, product: @product)
    assert_not item.valid?
    assert_equal ["must exist"], item.errors[:cart]
  end

  test "invalid without product" do
    item = build(:cart_item, cart: @cart, product: nil)
    assert_not item.valid?
    assert_equal ["must exist"], item.errors[:product]
  end

  test "invalid with non-positive quantity" do
    item = build(:cart_item, quantity: 0)
    assert_not item.valid?
    assert_includes item.errors[:quantity], "must be greater than 0"
  end

  test "invalid with non-integer quantity" do
    item = build(:cart_item, quantity: 1.5)
    assert_not item.valid?
    assert_includes item.errors[:quantity], "must be an integer"
  end

  test "does not allow duplicate products in same cart" do
    create(:cart_item, cart: @cart, product: @product)
    duplicate_item = build(:cart_item, cart: @cart, product: @product)

    assert_not duplicate_item.valid?
    assert_equal ["has already been taken"], duplicate_item.errors[:product_id]
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

    assert_match /has already been taken/, exception.message
  end

  test "should have proper unique index in database" do
    indexes = ActiveRecord::Base.connection.indexes(:cart_items)
    assert indexes.any? { |i| i.columns == ["product_id", "cart_id"] && i.unique }
  end
end
