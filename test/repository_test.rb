require File.join(File.dirname(__FILE__), 'test_helper')

class RepositoryTest < Test::Unit::TestCase
  include Cockpit

  def setup
    fake_everything
  end

  should "be able to find a repo for a user" do
    repo = Repository.find("tester", :user => 'coreycollins')
    assert_not_nil repo
    assert_equal 'tester', repo.name
  end

  should "be able to find all repos for a user" do
    repos = Repository.find_all(:user => "coreycollins")
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
      Repository.find_all(:user => "i-am-most-probably-a-user-that-does-not-exist")
    end
    assert_equal "The Repository could not be found or created. It could be private.", exception.message
  end

  context "authenticated" do

    should "be able to find a repo" do
      auth do
        repo = Repository.find("tester")
        assert_not_nil repo
        assert_equal 'tester', repo.name
      end
    end

    should "return current authenticated users repositpries" do
      auth do
        repos = User.current.repositories
        assert_not_nil repos
        assert_equal true, repos.map{ |r| r.to_s }.include?('tester')
      end
    end

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

    should "create a  public repo for current authenticated user" do
      auth do
        repo = Repository.create('tester', :public => true)
        assert_not_nil repo
        assert_equal 'tester', repo.name
      end
    end

    should "return repos tags" do
      auth do
        tags = Repository.find('tester').tags
        assert_not_nil tags
        assert_equal true, tags.map{ |t| t.to_s }.include?('0.1')
      end
    end

    should "return repos branches" do
      auth do
        branches = Repository.find('tester').branches
        assert_not_nil branches
        assert_equal true, branches.map{ |b| b.to_s }.include?('new')
      end
    end

    should "return repos commits for current user" do
      auth do
        commits = Repository.find('tester').commits
        assert_not_nil commits
        assert_equal true, commits.map{ |c| c.sha }.include?('b6e7a02bb2d39d42843e753dc9af162d6de24882')
      end
    end

  end

end
