
module ActiveVlc
  class Runner
    def initialize(pipeline, *args)
      @pipeline = pipeline
      @api = LibVlc::Instance.new args
    end

    # Here we setup the media/list/player/event_manager
    # to run the pipeline using LibVlc. There's a big unavoidable
    # hack to run synchronously / 'join' the libvlc instance.
    def run
      # Preparing list/player/sout fragment/event manager
      sout = @pipeline.sout.fragment
      list = @api.create_media_list
      player = @api.create_player
      events = player.event_manager

      sout.gsub!('\'', '').gsub!('"', '')

      # Building the medias with the right options
      medias = @pipeline.input.inputs.map do |input|
        #puts sout
        @api.create_media(input) << sout
      end
      medias.each { |media| list << media }
      list_player = @api.create_list_player list, player

      # Set callbacks to 'know' when the processing is over
      stop_events = [
        :MediaPlayerPaused,
        :MediaPlayerStopped,
        :MediaPlayerEndReached,
        :MediaPlayerEncounteredError
      ]
      events.on(stop_events) { stop_runner! }

      # Let's rock and roll
      list_player.play

      # Busy Wait loop hack to synchronize with libvlc which doesn't have
      # any synchronous interface (due to it's profound asynchronous nature)
      @running = true
      while @running
        sleep 0.5
      end
    end

    # Nobody can escape his faith.
    def stop_runner!
      @running = false
    end
  end
end
