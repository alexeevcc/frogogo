class CartsController < ApplicationController
  def show
    @items = CartItem.all
  end
end
