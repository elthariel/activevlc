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
    attr_reader :media
    def initialize(vlc_or_media)
      @media = nil
      if vlc_or_media.is_a?(Media)
        @media = vlc_or_media
        @ptr = Api.libvlc_media_player_new_from_media(vlc_or_media.ptr)
      else
        @ptr = Api.libvlc_media_player_new(vlc_or_media.ptr)
      end
    end

    def media=(new_media)
    end

  end
end
