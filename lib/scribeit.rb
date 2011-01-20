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
    @logger = ScribeIt::Log.new STDERR
  end

  def register
    if !@config.has_key? "sources"
      raise "Config error - no sources defined"
    end

    sources = @config["sources"]
    sources.each do |source|
      puts source.inspect
      if source.is_a? Array or source.is_a? Hash
        cat, files = source
      else
        raise "Config error - no category for file: #{files.inspect}"
      end

      files = [files] if !files.is_a? Array

      files.each do |f|
        @logger.debug("Adding new source #{f} to category #{cat}")
        s = ScribeIt::Source.new(f, cat) { |event| fire(event) }
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
    @signals = EventMachine::Channel.new

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
    @logger.debug("Firing a new event at scribe for #{event.inspect}")
    @scribe.log(event[:event], event[:category])
  end

end
