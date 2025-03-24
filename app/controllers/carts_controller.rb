class CartsController < ApplicationController
  def show
    @items = @cart.cart_items
    @products = Product.all
  end

  def clear ;end
end
