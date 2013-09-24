module ActiveVlc::LibVlc
  class MediaListPlayerPtr < FFI::ManagedStruct
    layout :nothing, :pointer

    def self.release(ptr)
      puts "Releasing a MediaListPlayerPtr"
      Api.libvlc_media_list_player_release(ptr)
    end
  end

  class MediaListPlayer
    attr_reader :ptr

    def initialize(ptr, media_list = nil)
      @ptr = MediaListPlayerPtr.new(ptr)
      self.media_list = media_list if media_list
    end

    def media_list=(list)
      if list and list.is_a?(MediaList)
        Api.libvlc_media_list_player_set_media_list(@ptr, list.ptr)
      else
        raise "You must provide a valid MediaList"
      end
    end

    def event_manager
      EventManager.new Api.libvlc_media_list_player_event_manager(@ptr)
    end

    def play
      Api.libvlc_media_list_player_play(@ptr)
    end
    def pause
      Api.libvlc_media_list_player_pause(@ptr)
    end
    def stop
      Api.libvlc_media_list_player_stop(@ptr)
    end
    def next
      Api.libvlc_media_list_player_next(@ptr)
    end
    def previous
      Api.libvlc_media_list_player_previous(@ptr)
    end
  end
end
