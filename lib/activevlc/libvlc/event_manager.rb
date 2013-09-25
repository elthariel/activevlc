module ActiveVlc::LibVlc
  class Event < FFI::Struct
    layout :type, :int,
           :object, :pointer
  end

  class EventManager
    EventType = Api::EventType

    attr_reader :callbacks, :events_received

    def initialize(ptr)
      @ptr = ptr
      @callbacks = {}
      @events_received = 0

      @event_handler = Proc.new { |event, void| _event(event, void) }
    end

    def on(type, &block)
      event_is_valid = true

      # Get the enum value if we gat a Symbol or String
      if type.is_a?(String) or type.is_a?(Symbol)
        type = EventType[type.to_sym]
      end

      # If this is the first callback for this type, register the :event_handler
      # using vlc's API and create the proc array for that 'type'.
      unless @callbacks[type]
        event_is_valid = Api.libvlc_event_attach(@ptr, type, @event_handler, nil) == 0
        @callbacks[type] = Array.new if event_is_valid
      end
      @callbacks[type].push block if event_is_valid
    end

    protected
    def _event(event, void)
      event = Event.new(event)

      @events_received += 1;

      #puts "Received event: #{EventType[event[:type]]}"
    end
  end
end
