require File.join(File.dirname(__FILE__), 'test_helper')

class ReferenceTest < Test::Unit::TestCase
  include Fuselage

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

    should "be able to create a reference" do
      auth do
        ref = Reference.create('tester', 'refs/heads/test', '6c5b0e754460477ed049e5b1b0785e667eadaeb9')
        assert_not_nil ref
        assert_equal 'refs/heads/test', ref.ref
      end
    end

  end

end
