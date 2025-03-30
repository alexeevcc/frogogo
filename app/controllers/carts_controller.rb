class CartsController < ApplicationController
  def show
    @products = Product.all
  end

  def update_discount
    @cart.update(discount: params[:discount])
  end

  def clear
    @cart.clear
  end
end
