require "test_helper"

class CartsControllerTest < ActionDispatch::IntegrationTest
  test "should get cart page on root path" do
    get root_path
    assert_response :success

    assert_select "h1", "Корзина"
  end
end
