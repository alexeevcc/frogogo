require "test_helper"

class ProductTest < ActiveSupport::TestCase
  test "should create product with valid attributes" do
    product = Product.new(name: "Беспроводная колонка", price: 1600.00)
    assert product.valid?
  end

  test "should not create product without name" do
    product = Product.new(price: 1600.00)
    assert_not product.valid?
    assert_equal ["can't be blank"], product.errors[:name]
  end

  test "should not create product without price" do
    product = Product.new(name: "Беспроводная колонка")
    assert_not product.valid?
    assert_equal ["can't be blank"], product.errors[:price]
  end
end

