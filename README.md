# Entities
## Product
- id (bigint)
- uuid (string)
- created_at (datetime)
- updated_at (datetime)
- image (string)
- name (string)
- price (decimal)

## Cart
- id (bigint)
- created_at (datetime)
- updated_at (datetime)
- discount (decimal)
- total_price (decimal)
- final_price (decimal)

## CartItem
- id (bigint)
- created_at (datetime)
- updated_at (datetime)
- cart_id (bigint)
- product_id (bigint)
- quantity (integer)

# UseCases
- IncreaseCartItemQuantity
- DecreaseCartItemQuantity
- RemoveCartItem
- ClearCart
- ChangeCartDiscount
