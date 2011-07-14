require File.join(File.dirname(__FILE__), 'test_helper')

class UserTest < Test::Unit::TestCase
  include Cockpit

  def setup
    fake_everything
  end

  should "be able to find a user" do
    u = User.find("coreycollins")
    assert_not_nil u
    assert_equal "coreycollins", u.login
  end

  should "not be able to find a user that doesn't exist" do
    exception = assert_raise NotFound do 
      User.find("i-am-most-probably-a-user-that-does-not-exist")
    end
    
    assert_equal "The User you were looking for could not be found, or is private.", exception.message
  end

  should "not be able to get current user if not authenticated" do
    assert_raise AuthenticationRequired do
     User.current
    end
  end

  context "authenticated" do

    before do
      auth do
        @user = User.current
      end
    end

    should "return current authenticated user information" do
      assert_not_nil @user
      assert_equal "coreycollins", @user.login
    end

    should "get users emails" do
      assert_not_nil @user.emails
    end

  end

end
