require File.join(File.dirname(__FILE__), 'test_helper')

class BaseTest < Test::Unit::TestCase
  include Fuselage

  class TestModel < Fuselage::Base 
    attr_accessor :some_attribute
  end
  
  def setup
    fake_everything
  end
  
  should "should have attribute method when created" do
    assert_respond_to TestModel.new, 'some_attribute'
  end
end
