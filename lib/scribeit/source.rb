class ScribeIt
  class Source
    def initialize(file, category, &block)
      @logger = ScribeIt::Log.new STDERR
      @file = file
      @callback = block
      @category = category
    end

    def register
      @logger.info "Registering #{@file}"
      EventMachine::FileGlobWatchTail.new(@file, Reader, interval=60, exclude=[], receiver=self)
    end

    def receive(filetail, event)
      @logger.debug "File #{@file} got event: #{event.inspect}"
      e = {:event => event, :category => @category}
      @callback.call e
    end

    private
    class Reader < EventMachine::FileTail
      def initialize(path, receiver)
        super path
        @receiver = receiver
        @buffer = BufferedTokenizer.new
      end

      def receive_data(data)
        @buffer.extract(data).each do |line|
          @receiver.receive(self, line)
        end
      end
    end

  end
end
