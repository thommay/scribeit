require 'logger'

class ScribeIt
  class Log < Logger

    def initialize(*args)
      super(*args)
      self.level = $DEBUG ? Logger::DEBUG : Logger::INFO
      @formatter.progname = File.basename $0
    end

    def level=(level)
      super(level)
      @formatter.level = level
    end

  end

end

