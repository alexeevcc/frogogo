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
  end
end
