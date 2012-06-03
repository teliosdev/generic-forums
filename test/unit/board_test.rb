require 'test_helper'
require 'application_helper'

class BoardTest < ActiveSupport::TestCase
  include ApplicationHelper
  # test "the truth" do
  #   assert true
  # end

  test "board permissions" do
    assert_instance_of Permission, resolve_board(boards(:primary), users(:user))
    assert resolve_board(boards(:primary), users(:user)).read?
    assert resolve_board(boards(:secondary), users(:user)).read?
    assert !resolve_board(boards(:secondary), users(:guest)).read?
  end
end
