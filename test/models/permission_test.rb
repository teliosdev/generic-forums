require 'test_helper'

class PermissionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "user can read category" do
    user = users(:some_user)
    ability = Ability.new(user)

    assert ability.can?(:read, categories(:first_category))
  end
end
