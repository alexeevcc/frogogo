module CartSessions
  extend ActiveSupport::Concern

  included do
    helper_method :current_cart
  end

  private

  def current_cart
    @cart ||= find_or_create_cart
  end

  def find_or_create_cart
    if session[:cart_uuid]
      Cart.find_by(uuid: session[:cart_uuid]) || create_new_cart
    else
      create_new_cart
    end
  end

  def create_new_cart
    cart = Cart.create!
    session[:cart_uuid] = cart.uuid
    cart
  end
end
