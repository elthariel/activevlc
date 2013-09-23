
module ActiveVlc::LibVlc
  def self.version
    Api.libvlc_get_version
  end
  def self.compiler
    Api.libvlc_get_compiler
  end

  module Api
    extend FFI::Library
    ffi_lib ActiveVlc::LibVlc::VLC_SO_NAMES

    #
    # Core functions
    #
    callback :exit_handler, [:pointer], :void

    core_functions = {
     libvlc_new:              [[:int, :pointer], :pointer],
     libvlc_release:          [[:pointer], :void],
     libvlc_retain:           [[:pointer], :void],
     libvlc_add_intf:         [[:pointer, :string], :int],
     libvlc_set_exit_handler: [[:pointer, :exit_handler, :pointer], :void],
     libvlc_wait:             [[:pointer], :void],
     libvlc_set_user_agent:   [[:pointer, :string, :string], :void],
     libvlc_get_version:      [[], :string],
     libvlc_get_compiler:     [[], :string],
     libvlc_free:             [[:pointer], :void]
   }

    #
    # Media functions
    #
    media_functions = {
      libvlc_media_new_location:    [[:pointer, :string], :pointer],
      libvlc_media_new_path:        [[:pointer, :string], :pointer],
      libvlc_media_add_option:      [[:pointer, :string], :void],
      libvlc_media_add_option_flag: [[:pointer, :string, :int], :void],
      libvlc_media_duplicate:       [[:pointer], :pointer],
      libvlc_media_event_manager:   [[:pointer], :pointer]
    }

    [core_functions, media_functions].each do |functions|
      functions.each do |symbol, args|
        attach_function symbol, args[0], args[1]
      end
    end
  end
end

