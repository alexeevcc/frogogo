require "test_helper"

class ProductTest < ActiveSupport::TestCase
  setup do
    @product_attrs = {
      name: "Беспроводная колонка",
      price: 1600.00
    }
  end

  test "should create product with valid attributes" do
    product = build(:product, @product_attrs)
    assert product.valid?
  end

  test "should require name" do
    product = build(:product, name: nil)
    assert_not product.valid?
    assert_equal ["can't be blank"], product.errors[:name]
  end

  test "should require price" do
    product = build(:product, price: nil)
    assert_not product.valid?
    assert_equal ["can't be blank", "is not a number"], product.errors[:price]
  end

  test "should validate price numericality" do
    product = build(:product, price: "invalid")
    assert_not product.valid?
    assert_equal ["is not a number"], product.errors[:price]
  end

  test "should validate price is greater than 0" do
    product = build(:product, price: 0)
    assert_not product.valid?
    assert_equal ["must be greater than 0"], product.errors[:price]
  end

  test "should validate price precision" do
    product = build(:product, price: 1234.567)
    assert product.valid?
    assert_equal 1234.57.to_d, product.price
  end

  test "should have cart_items association" do
    assert_respond_to Product.new, :cart_items
  end

  test "should destroy associated cart_items when destroyed" do
    product = create(:product)
    create(:cart_item, product: product)

    assert_difference('CartItem.count', -1) do
      product.destroy!
    end
  end

  test "should have image attachment" do
    assert_respond_to Product.new, :image
  end

  test "should accept valid image attachment" do
    product = create(:product)
    product.image.attach(
      io: File.open(Rails.root.join('test/fixtures/files/sample.jpg')),
      filename: 'sample.jpg',
      content_type: 'image/jpg'
    )

    assert product.image.attached?
  end

  test "should validate image content type" do
    product = build(:product)
    product.image.attach(
      io: File.open(Rails.root.join('test/fixtures/files/sample.pdf')),
      filename: 'sample.pdf',
      content_type: 'application/pdf'
    )

    assert_not product.valid?
    assert_equal ["has an invalid content type (authorized content types are PNG, JPG, WEBP)"], product.errors[:image]
  end
end
