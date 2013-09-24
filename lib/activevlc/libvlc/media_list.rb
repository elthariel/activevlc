module ActiveVlc::LibVlc
  # See InstancePtr in instance.rb
  class MediaListPtr < FFI::ManagedStruct
    layout :media_list, :pointer

    def self.release(ptr)
      puts "Releasing an MediaListPtr"
      Api.libvlc_media_list_release(ptr)
    end
  end

  class MediaList
    attr_reader :ptr

    def initialize(ptr)
      @ptr = MediaListPtr.new(ptr)
    end

    # Execute the given block with the media_list lock acquired.
    def locked!
      if block_given?
        _lock!
        res = yield
        _unlock!
        res
      end
    end

    def event_manager
      EventManager.new Api.libvlc_media_list_event_manager(@ptr)
    end

    def media=(media)
      Api.libvlc_media_list_set_media(@ptr, media.ptr)
    end

    def <<(media)
      locked! { Api.libvlc_media_list_add_media(@ptr, media.ptr) }
    end

    def length
      locked! { Api.libvlc_media_list_count(@ptr) }
    end

    protected
    def _lock!
      Api.libvlc_media_list_lock(@ptr)
    end
    def _unlock!
      Api.libvlc_media_list_unlock(@ptr)
    end


  end
end
