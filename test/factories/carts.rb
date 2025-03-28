# test/factories/carts.rb
FactoryBot.define do
  factory :cart do
    transient do
      items_count { 0 }
      product_price { 100.00 }
    end

    total_price { 0.0 }
    discount { 0.0 }
    final_price { 0.0 }

    trait :with_items do
      transient do
        items_count { 3 }
      end

      after(:create) do |cart, evaluator|
        evaluator.items_count.times do
          create(:cart_item,
                 cart: cart,
                 product: create(:product, price: evaluator.product_price))
        end
        cart.reload
      end
    end

    trait :with_discount do
      discount { 50.0 }
      final_price { total_price - discount }
    end

    trait :with_total do
      total_price { 500.0 }
      final_price { total_price - discount }
    end
  end
end
