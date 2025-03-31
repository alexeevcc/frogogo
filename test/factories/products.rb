# test/factories/products.rb
FactoryBot.define do
  factory :product do
    sequence(:name) { |n| "Product #{n}" }
    price { 1600.00 }

    trait :with_image do
      after(:build) do |product|
        product.image.attach(
          io: File.open(Rails.root.join('test/fixtures/files/sample.jpg')),
          filename: 'sample.jpg',
          content_type: 'image/jpg'
        )
      end
    end
  end
end
