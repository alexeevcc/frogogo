class ApplicationController < ActionController::Base
  include CartSessions

  before_action :set_cart

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # allow_browser versions: :modern

  def home ;end

  private

  def set_cart
    current_cart
  end
end
