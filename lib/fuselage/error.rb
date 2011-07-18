module Fuselage
  
  class RegisterError < StandardError; end
  
  class FormatError < StandardError
   def initialize(f)
     super("Got unexpected format (got #{f.first} for #{f.last})")
   end
  end
  
  class AuthenticationRequired < StandardError
  end

  class APIError < StandardError
  end
  
  class InvalidLogin < StandardError
  end

  class ArgumentMustBeHash < Exception; end
  
  class NotFound < Exception
    def initialize(klass)
      super "The #{klass.to_s.split("::").last} could not be found or created. It could be private."
    end
  end
  
end
