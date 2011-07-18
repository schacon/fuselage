require File.join(File.dirname(__FILE__), 'test_helper')

class BlobTest < Test::Unit::TestCase
  include Fuselage

  def setup
    fake_everything
  end

  context "authenticated" do

    should "be able to find a blob" do
      auth do
        blob = Blob.find('tester','6c5b0e754460477ed049e5b1b0785e667eadaeb9')
        assert_not_nil blob
        assert_equal '6c5b0e754460477ed049e5b1b0785e667eadaeb9', blob.sha
      end
    end

    should "be able to create a blob" do
      auth do
        blob = Blob.create('tester', 'Some test content')
        assert_not_nil blob
      end
    end

  end

end
