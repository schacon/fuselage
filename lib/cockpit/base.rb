module Cockpit
  class Base

    attr_accessor :api
    
    def initialize(attributes={})
      # Useful for finding out what attr_accessor needs for classes
      # puts caller.first.inspect
      # puts "#{self.class.inspect} #{attributes.keys.map { |s| s.to_sym }.inspect}"
      attributes.each do |key, value|
        method = "#{key}="
        self.send(method, value) if respond_to? method
      end
    end
    
  end
end
