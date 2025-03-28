FactoryBot.define do
  factory :product do
    sequence(:name) { |n| "Product #{n}" }
    price { 1000.00 }

    trait :with_image do
      after(:build) do |product|
        product.image.attach(
          io: File.open(Rails.root.join('test/fixtures/files/sample.jpg')),
          filename: 'sample.jpg',
          content_type: 'image/jpg'
        )
      end
    end

    trait :expensive do
      price { 10_000.00 }
    end

    trait :cheap do
      price { 99.99 }
    end
  end
end
