module Onena
  module Error
	class InvalidFormat < StandardError
	  def initialize(message: 'Invalid format')
		super(message)
	  end
	end

	class ArgumentMissing < StandardError
	end
  end
end
