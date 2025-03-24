class CartItemsController < ApplicationController
  def create
    product = Product.find(params[:product_id])
    @cart.cart_items.create(product_id: product.id) if product.present?
  end

  def update ;end

  def destroy ;end
end
