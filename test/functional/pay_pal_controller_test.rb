require 'test_helper'

class PayPalControllerTest < ActionController::TestCase
  test "should get return" do
    get :return
    assert_response :success
  end

  test "should get cancel" do
    get :cancel
    assert_response :success
  end

  test "should get create" do
    get :create
    assert_response :success
  end

end
