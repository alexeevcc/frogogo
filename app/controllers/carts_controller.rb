class CartsController < ApplicationController
  def show
    @products = Product.all
  end

  def clear ;end
end
