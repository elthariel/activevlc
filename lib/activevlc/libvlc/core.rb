
module ActiveVlc::LibVlc
  module Core
    extend FFI::Library
    ffi_lib ActiveVlc::LibVlc::VLC_SO_NAMES
    #ffi_lib ActiveVlc::LibVlc::VLCCORE_SO_NAMES

    callback :exit_handler, [:pointer], :void

    attach_function :libvlc_new, [:int, :pointer], :pointer
    attach_function :libvlc_release, [:pointer], :void
    attach_function :libvlc_retain, [:pointer], :void
    attach_function :libvlc_add_intf, [:pointer, :string], :int
    attach_function :libvlc_set_exit_handler, [:pointer, :exit_handler, :pointer], :void
    attach_function :libvlc_wait, [:pointer], :void
    attach_function :libvlc_set_user_agent, [:pointer, :string, :string], :void
    #attach_function :libvlc_set_app_id, [:pointer, :string, :string, :string], :void
    attach_function :libvlc_get_version, [], :string
    attach_function :libvlc_get_compiler, [], :string
    attach_function :libvlc_free, [:pointer], :void
  end

  def self.version
    Core.libvlc_get_version
  end
  def self.compiler
    Core.libvlc_get_compiler
  end

  # This is just a hack to have the libvlc_instance released when
  # the Instance class is GC'ed
  class InstancePtr < FFI::ManagedStruct
    layout :vlc_instance, :pointer

    def self.release(ptr)
      Core.libvlc_release(ptr)
    end
  end

  class Instance
    attr_reader :exit_callback, :vlc

    def initialize(args)
      argc = args.length
      @argv = args.map{ |a| FFI::MemoryPointer.from_string a}
      test = FFI::MemoryPointer.new(:pointer, argc)
      test.put_array_of_pointer(0, @argv)
      #args.each_index do |i|
      #  @argv.put_pointer i, FFI::MemoryPointer.from_string(args[i])
      #end
      #@argv.write_array_of_type(:pointer, :put_string, args)

      @vlc = Core.libvlc_new(argc, test)
      raise "Unable to create a libvlc_instance_t" if @vlc.null?

      @vlc_ptr = InstancePtr.new(@vlc) # See InstancePtr doc

    end

    def wait!
      Core.libvlc_wait(@vlc)
    end

    def at_exit(&block)
      Core.libvlc_set_exit_handler(@vlc, nil, nil)
      @exit_callback = block
      Core.libvlc_set_exit_handler(@vlc, @exit_callback, nil)
    end

    def add_interface(name = nil)
      Core.libvlc_add_intf(@vlc, name)
    end
  end
end

