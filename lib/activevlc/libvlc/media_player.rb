module ActiveVlc::LibVlc
  # See InstancePtr in instance.rb
  class MediaPlayerPtr < FFI::ManagedStruct
    layout :media_list, :pointer

    def self.release(ptr)
      # puts "Releasing an MediaPlayerPtr"
      Api.libvlc_media_player_release(ptr)
    end
  end

  class MediaPlayer
    attr_reader :ptr, :media

    def initialize(vlc_or_media)
      @media = nil
      if vlc_or_media.is_a?(Media)
        @media = vlc_or_media
        @ptr = Api.libvlc_media_player_new_from_media(vlc_or_media.ptr)
      else
        @ptr = Api.libvlc_media_player_new(vlc_or_media.ptr)
      end
    end

    def event_manager
      event_manger = Api.libvlc_media_player_event_manager(@ptr)
      raise "Unable to get EventManager for MediaPlayer #{@ptr.inspect}" unless event_manger
      EventManager.new event_manger
    end

    def media=(new_media)
      raise "You must provide a valid Media" unless new_media and new_media.is_a?(Media)
      @media = new_media
      Api.libvlc_media_player_set_media(@ptr, @media.ptr)
    end

    def play
      if_media { Api.libvlc_media_player_play @ptr }
    end
    def stop
      if_media { Api.libvlc_media_player_stop @ptr }
    end
    def pause
      if_media { Api.libvlc_media_player_pause @ptr}
    end

    def playing?
      Api.libvlc_media_player_is_playing @ptr
    end

    def state
      Api.libvlc_media_player_get_state @ptr
    end

    protected
    def if_media
      if block_given?
        raise "MediaPlayer: No media set" unless @media
        yield
      end
    end
  end
end
