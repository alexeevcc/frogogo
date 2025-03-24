class ApplicationController < ActionController::Base
  before_action :initialize_cart

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # allow_browser versions: :modern

  def home ;end

  private

  def initialize_cart
    @cart ||= Cart.find_by_secret_id(session[:cart_secret_id])

    if @cart.nil?
      @cart = Cart.create
      session[:cart_secret_id] = @cart.secret_id
    end
  end
end
