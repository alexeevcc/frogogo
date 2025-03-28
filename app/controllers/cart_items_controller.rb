class CartItemsController < ApplicationController
  before_action :set_product, only: [:create]
  before_action :set_cart_item, only: [:update, :destroy]

  def create
    @item = @cart.cart_items.find_or_initialize_by(product: @product)
    @item.quantity = @item.persisted? ? @item.quantity + 1 : 1
    @item.save!
  end

  def update
    @item.update(cart_item_params)
  end

  def destroy
    @item.destroy!
  end

  private

  def set_product
    @product = Product.find(params[:product_id])
  end

  def set_cart_item
    @item = @cart.cart_items.find(params[:id])
  end

  def cart_item_params
    params.require(:cart_item).permit(:quantity)
  end
end
