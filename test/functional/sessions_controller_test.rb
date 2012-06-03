require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should post create" do
    post :create
    assert_response :success
  end

  test "should delete destroy" do
    delete :destroy
    assert_response :redirect
  end

end
