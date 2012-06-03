require 'test_helper'

class BoardsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get show" do
    get :show, :id => boards(:primary).id
    assert_response :success
  end

end
