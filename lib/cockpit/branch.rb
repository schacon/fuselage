module Cockpit
  class Branch < Base
    attr_accessor :name, :sha

    def to_s
      name
    end

  end
end
