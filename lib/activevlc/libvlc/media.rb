module ActiveVlc::LibVlc
  # See InstancePtr in instance.rb
  class MediaPtr < FFI::ManagedStruct
    layout :nothing, :pointer

    def self.release(ptr)
      # puts "Releasing a MediaPtr #{ptr.inspect}"
      Api.libvlc_media_release(ptr)
    end
  end

  class Media
    attr_reader :ptr, :mrl

    def initialize(ptr, mrl)
      @ptr = MediaPtr.new(ptr)
      @mrl = mrl
    end

    def <<(option)
      raise "option must be a String" unless option.is_a?(String)

      Api.libvlc_media_add_option(@ptr, option)
    end

    def event_manager
      EventManager.new Api.libvlc_media_event_manager(@ptr)
    end

  end
end
