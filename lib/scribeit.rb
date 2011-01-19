require 'eventmachine'
require 'eventmachine-tail'
require 'scribe'
require 'scribeit/source'
require 'scribeit/log'

class ScribeIt
  
  attr_reader :config
  attr_reader :sources

  def initialize(config)
    @config = config
    @sources = []
    @scribe = Scribe.new
  end

  def register

    if !@config.has_key? "sources"
      raise "Config error - no sources defined"
    end

    sources = @config["sources"]
    sources.each do |source|
      if source.is_a? Hash
        cat, files = value
      else
        raise "Config error - no category for file: #{files.inspect}"
      end

      files = [files] if !files.is_a? Array

      files.each do |f|
        s = ScribeIt::Source.new(f, type) { |event| receive(event) }
        s.register
        @sources << s
      end
    end

    register_signal_handler
  end

  def run(&block)
    EventMachine.run do
      self.register
      yield if block_given?
    end
  end

  def stop
    EventMachine.stop_event_loop
  end

  def register_signal_handler
    @sigals = EventMachine::Channel.new

    Signal.trap("INT") do
      @signals.push(:INT)
    end

    Signal.trap("USR1") do
      @signals.push(:USR1)
    end

    @signals.subscribe do |msg|
      case msg
      when :USR1
        #eventually, we want to reload our config.
        # for now, we'll just show what we're looking at.
        puts @sources
      when :INT
        EventMachine.stop_event_loop
      end
    end
  end

  protected

  def fire(event)
    @scribe.log(event.data, event.category)
  end

  def receive(event)
    if !event.cancelled?
      fire(event)
    end
  end

end
