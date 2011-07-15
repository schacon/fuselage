require File.join(File.dirname(__FILE__), 'test_helper')

class ReferenceTest < Test::Unit::TestCase
  include Cockpit

  def setup
    fake_everything
  end

  context "authenticated" do

    should "be able to find a reference" do
      auth do
        ref = Reference.find('tester','heads/master')
        assert_not_nil ref
        assert_equal 'refs/heads/master', ref.ref
      end
    end

    should "be able to find all references" do
      auth do
        refs = Reference.find_all('tester')
        assert_not_nil refs
        assert_equal true, refs.map{ |r| r.to_s }.include?('refs/heads/master')
      end
    end

  end

end
