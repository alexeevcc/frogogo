class CartsController < ApplicationController
  def show
    @products = Product.all
  end

  def update
    @cart.update(cart_params)
  end

  def clear
    @cart.clear
  end

  private

  def cart_params
    params.require(:cart).permit(:discount)
  end
end
