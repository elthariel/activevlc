#
# Small note about this file code's coverage
# Since most of the code is wan in another process
# (see #run), the code coverage cannot be reported.
# This file have around 100% of test code coverage
#
module ActiveVlc
  class Runner
    def initialize(pipeline, *args)
      @pipeline = pipeline
      @args = args
    end

    # Nobody can escape his faith.
    def stop_runner!
      @running = false
    end

    def run(opts = {})
      opts = {type: :process}
      if opts[:type] == :form and Process.respond_to? :fork
        pid = Process.fork { _run; exit 0 }
        Process.wait pid
      elsif opts[:type] == :system
        fragment = @pipeline.fragment
        vlc_path = opts[:vlc_path]
        vlc_path ||= 'vlc'
        `#{vlc_path} #{@args.join ' '} #{fragment} vlc://quit`
      elsif opts[:type] == :process
        _run
      end
    end

    protected
    # Here we setup the media/list/player/event_manager
    # to run the pipeline using LibVlc. There's a big unavoidable
    # hack to run synchronously / 'join' the libvlc instance.
    def _run
      # Preparing instance/list/player/sout fragment/event manager
      @api = LibVlc::Instance.new @args
      sout = @pipeline.sout.fragment
      list = @api.create_media_list
      player = @api.create_player
      events = player.event_manager

      sout.gsub!('\'', '')
      sout.gsub!('"', '')

      puts sout

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

  end
end
