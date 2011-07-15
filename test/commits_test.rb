require File.join(File.dirname(__FILE__), 'test_helper')

class CommitTest < Test::Unit::TestCase
  include Cockpit

  def setup
    fake_everything
  end

  context "authenticated" do

    should "be able to find a commit" do
      auth do
        commit = Commit.find('tester','6c5b0e754460477ed049e5b1b0785e667eadaeb9')
        assert_not_nil commit
        assert_equal '6c5b0e754460477ed049e5b1b0785e667eadaeb9', commit.sha
      end
    end

    should "be able to create a commit" do
      auth do
        commit = Commit.create('tester', 'sample test commit', '5f2d10379330f0f76caa31d87e4bca4cefcdc3fd', ['6c5b0e754460477ed049e5b1b0785e667eadaeb9'])
        assert_not_nil commit
        assert_equal 'sample test commit', commit.message
      end
    end

  end

end
