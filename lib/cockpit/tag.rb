module Cockpit
  class Tag < Base
    attr_accessor :name, :sha

    def to_s
      name
    end

  end
end
