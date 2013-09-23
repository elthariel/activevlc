module ActiveVlc::LibVlc
  # This is just a hack to have the libvlc_instance released when
  # the Instance class is GC'ed
  class InstancePtr < FFI::ManagedStruct
    layout :vlc_instance, :pointer

    def self.release(ptr)
      Api.libvlc_release(ptr)
    end
  end

  class Instance
    attr_reader :exit_callback, :vlc

    def initialize(args)
      argc = args.length
      @argv = args.map{ |a| FFI::MemoryPointer.from_string a}
      test = FFI::MemoryPointer.new(:pointer, argc)
      test.put_array_of_pointer(0, @argv)

      @vlc = Api.libvlc_new(argc, test)
      raise "Unable to create a libvlc_instance_t" if @vlc.null?

      @vlc_ptr = InstancePtr.new(@vlc) # See InstancePtr doc
    end

    def wait!
      Api.libvlc_wait(@vlc)
    end

    def at_exit(&block)
      Api.libvlc_set_exit_handler(@vlc, nil, nil)
      @exit_callback = block
      Api.libvlc_set_exit_handler(@vlc, @exit_callback, nil)
    end

    def add_interface(name = nil)
      Api.libvlc_add_intf(@vlc, name)
    end
  end

end
