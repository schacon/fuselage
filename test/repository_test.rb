require File.join(File.dirname(__FILE__), 'test_helper')

class RepositoryTest < Test::Unit::TestCase
  include Cockpit

  def setup
    fake_everything
  end

  should "be able to find a repo for a user" do
    repos = Repository.find_by_username("coreycollins")
    assert_not_nil repos
    assert_equal true, repos.map{ |r| r.to_s }.include?('tester')
  end

  should "be able to find a repo for a organization" do
    repos = Repository.find_by_organization("gitpilot")
    assert_not_nil repos
    assert_equal true, repos.map{ |r| r.to_s }.include?('octopi')
  end

  should "not be able to find a repo for a user that doesn't exist" do
    exception = assert_raise NotFound do 
      Repository.find_by_username("i-am-most-probably-a-user-that-does-not-exist")
    end
    assert_equal "The Repository you were looking for could not be found, or is private.", exception.message
  end

  context "authenticated" do

    should "return current authenticated users repositpries" do
      auth do
        repos = User.current.repositories
        assert_not_nil repos
        assert_equal true, repos.map{ |r| r.to_s }.include?('tester')
      end
    end

    should "return current authenticated users repositpries within an organization" do
      auth do
        repos = User.current.repositories(:organization => 'gitpilot')
        assert_not_nil repos
        assert_equal true, repos.map{ |r| r.to_s }.include?('gitpilot_test')
      end
    end

    should "return current authenticated users repositpries within an organization that are private" do
      auth do
        repos = User.current.repositories(:organization => 'gitpilot', :type => :private)
        assert_not_nil repos
        assert_equal true, repos.map{ |r| r.to_s }.include?('gitpilot_test')
      end
    end

  end

end
