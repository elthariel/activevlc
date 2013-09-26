module ActiveVlc::LibVlc
  # This is just a hack to have the libvlc_instance released when
  # the Instance class is GC'ed
  class InstancePtr < FFI::ManagedStruct
    layout :nothing, :pointer

    def self.release(ptr)
      #puts "Releasing an InstancePtr #{ptr.inspect}"
      Api.libvlc_release(ptr)
    end
  end

  class Instance
    attr_reader :exit_callback, :ptr

    def initialize(args = [""])
      argc = args.length
      @argv = args.map{ |a| FFI::MemoryPointer.from_string a}
      test = FFI::MemoryPointer.new(:pointer, argc)
      test.put_array_of_pointer(0, @argv)

      @ptr = InstancePtr.new Api.libvlc_new(argc, test)
      raise "Unable to create a libvlc_instance_t" if @ptr.null?
    end

    def create_media(mrl)
      if mrl =~ /\A[a-z]+:\/\/.+/
        m = Api.libvlc_media_new_location(@ptr, mrl)
      else
        m = Api.libvlc_media_new_path(@ptr, mrl)
      end
      raise "Unable to create a libvlc_media_t" if m.null?
      Media.new(m, mrl)
    end

    def create_media_list
      ml = Api.libvlc_media_list_new(@ptr)
      raise "Unable to create a libvlc_media_list_t" if ml.null?
      MediaList.new(ml)
    end

    def create_list_player(list = nil, player = nil)
      mlp = Api.libvlc_media_list_player_new(@ptr)
      raise "Unable to create a libvlc_media_list_player_t" if mlp.null?
      MediaListPlayer.new(mlp, list, player)
    end

    def create_player(media = nil)
      if media and media.is_a?(Media)
        MediaPlayer.new(media)
      else
        MediaPlayer.new self
      end
    end

    def wait!
      Api.libvlc_wait(@ptr)
    end

    def at_exit(&block)
      Api.libvlc_set_exit_handler(@ptr, nil, nil)
      @exit_callback = block
      Api.libvlc_set_exit_handler(@ptr, @exit_callback, nil)
    end

    def add_interface(name = nil)
      Api.libvlc_add_intf(@ptr, name)
    end
  end

end
