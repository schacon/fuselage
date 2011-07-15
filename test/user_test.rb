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
    
    assert_equal "The User could not be found or created. It could be private.", exception.message
  end

  should "not be able to get current user if not authenticated" do
    assert_raise AuthenticationRequired do
     User.current
    end
  end

  context "authenticated" do

    should "return current authenticated user information" do
      auth do
        u = User.current
        assert_not_nil u
        assert_equal "coreycollins", u.login
      end
    end

    should "get users following" do
      auth do
        u = User.current
        assert_not_nil u
        assert_not_nil u.following
        assert_equal true, u.following.map{ |u| u.to_s }.include?('jprichardson')
      end
    end

    should "get users followers" do
      auth do
        u = User.current
        assert_not_nil u
        assert_not_nil u.followers
        assert_equal true, u.followers.map{ |u| u.to_s }.include?('gitpilot-team')
      end
    end

  end

end
