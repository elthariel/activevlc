module ActiveVlc::LibVlc
  class EventManager
    EventType = Api::EventType

    attr_reader :callbacks

    def initialize(ptr)
      @ptr = ptr
      @callbacks = {}

      @event_handler = Proc.new { |event, void| _event(event, void) }
    end

    def on(type, &block)
      # Get the enum value if we gat a Symbol or String
      if type.is_a?(String) or type.is_a?(Symbol)
        type = EventType["libvlc_#{type}".to_sym]
      end

      # If this is the first callback for this type, register the :event_handler
      # using vlc's API and create the proc array for that 'type'.
      unless @callbacks[type]
        @callbacks[type] = Array.new
        Api.libvlc_event_attach(@ptr, type, @event_handler, nil)
      end
      @callbacks[type].push block
    end

    protected
    def _event(event, void)
      puts "Received event: #{event}"
    end
  end
end
