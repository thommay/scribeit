require 'logger'

class ScribeIt
  class Log < Logger
    attr_reader :level

    def initialize(name)
      super(name)
      @level = $DEBUG ? Logger::DEBUG : Logger::INFO
    end

    def level=(level)
      super(level)
    end

  end

end

