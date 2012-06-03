require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "user validation" do
    test_user = User.new
    assert_raise ActiveRecord::RecordInvalid do
      test_user.save!
    end
    test_user.name = "test"
    test_user.email= "test@examplecom" # oops, dropped a period!
    test_user.password = "test"
    assert_raise ActiveRecord::RecordInvalid do
      test_user.save!
    end
    test_user.email = "test@example.com"
    assert_nothing_raised ActiveRecord::RecordInvalid do
      test_user.save!
    end
  end

  test "user group relations" do
    assert_equal users(:user).groups, [groups(:guest), groups(:user)]
  end
end
