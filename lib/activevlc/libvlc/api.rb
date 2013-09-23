
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
      libvlc_media_event_manager:   [[:pointer], :pointer],
      libvlc_media_retain:          [[:pointer], :void],
      libvlc_media_release:         [[:pointer], :void],
      libvlc_media_get_mrl:         [[:pointer], :string]
    }

    #
    # Media List functions
    #
    media_list_functions = {
      libvlc_media_list_new:            [[:pointer], :pointer],
      libvlc_media_list_retain:         [[:pointer], :void],
      libvlc_media_list_release:        [[:pointer], :void],
      libvlc_media_list_lock:           [[:pointer], :void],
      libvlc_media_list_unlock:         [[:pointer], :void],
      libvlc_media_list_event_manager:  [[:pointer], :pointer],
      libvlc_media_list_set_media:      [[:pointer, :pointer], :void],
      libvlc_media_list_add_media:      [[:pointer, :pointer], :int],
      libvlc_media_list_insert_media:   [[:pointer, :pointer, :int], :int],
      libvlc_media_list_count:          [[:pointer], :int]
    }

    #
    # Media List Player functions
    #
    media_list_player_functions = {
      libvlc_media_list_player_new:             [[:pointer], :pointer],
      libvlc_media_list_player_retain:          [[:pointer], :void],
      libvlc_media_list_player_release:         [[:pointer], :void],
      libvlc_media_list_player_event_manager:   [[:pointer], :pointer],
      libvlc_media_list_player_set_media_list:  [[:pointer, :pointer], :void],
      libvlc_media_list_player_play:            [[:pointer], :void],
      libvlc_media_list_player_pause:           [[:pointer], :void],
      libvlc_media_list_player_stop:            [[:pointer], :void],
      libvlc_media_list_player_next:            [[:pointer], :void],
      libvlc_media_list_player_previous:        [[:pointer], :void]
    }

    #
    # Event manager functions and types
    #
    callback :event_handler, [:pointer, :pointer], :void

    EventType = enum(
      :libvlc_MediaMetaChanged,          0,
      :libvlc_MediaSubItemAdded,
      :libvlc_MediaDurationChanged,
      :libvlc_MediaParsedChanged,
      :libvlc_MediaFreed,
      :libvlc_MediaStateChanged,

      :libvlc_MediaPlayerMediaChanged,   0x100,
      :libvlc_MediaPlayerNothingSpecial,
      :libvlc_MediaPlayerOpening,
      :libvlc_MediaPlayerBuffering,
      :libvlc_MediaPlayerPlaying,
      :libvlc_MediaPlayerPaused,
      :libvlc_MediaPlayerStopped,
      :libvlc_MediaPlayerForward,
      :libvlc_MediaPlayerBackward,
      :libvlc_MediaPlayerEndReached,
      :libvlc_MediaPlayerEncounteredError,
      :libvlc_MediaPlayerTimeChanged,
      :libvlc_MediaPlayerPositionChanged,
      :libvlc_MediaPlayerSeekableChanged,
      :libvlc_MediaPlayerPausableChanged,
      :libvlc_MediaPlayerTitleChanged,
      :libvlc_MediaPlayerSnapshotTaken,
      :libvlc_MediaPlayerLengthChanged,
      :libvlc_MediaPlayerVout,

      :libvlc_MediaListItemAdded,        0x200,
      :libvlc_MediaListWillAddItem,
      :libvlc_MediaListItemDeleted,
      :libvlc_MediaListWillDeleteItem,

      :libvlc_MediaListViewItemAdded,    0x300,
      :libvlc_MediaListViewWillAddItem,
      :libvlc_MediaListViewItemDeleted,
      :libvlc_MediaListViewWillDeleteItem,

      :libvlc_MediaListPlayerPlayed,     0x400,
      :libvlc_MediaListPlayerNextItemSet,
      :libvlc_MediaListPlayerStopped,

      :libvlc_MediaDiscovererStarted,    0x500,
      :libvlc_MediaDiscovererEnded,

      :libvlc_VlmMediaAdded,             0x600,
      :libvlc_VlmMediaRemoved,
      :libvlc_VlmMediaChanged,
      :libvlc_VlmMediaInstanceStarted,
      :libvlc_VlmMediaInstanceStopped,
      :libvlc_VlmMediaInstanceStatusInit,
      :libvlc_VlmMediaInstanceStatusOpening,
      :libvlc_VlmMediaInstanceStatusPlaying,
      :libvlc_VlmMediaInstanceStatusPause,
      :libvlc_VlmMediaInstanceStatusEnd,
      :libvlc_VlmMediaInstanceStatusError
      )

    event_manager_functions = {
      libvlc_event_attach:    [[:pointer, :int, :event_handler, :pointer], :int],
      libvlc_event_detach:    [[:pointer, :int, :event_handler, :pointer], :void],
      libvlc_event_type_name: [[:int], :string]
    }

    # Here we use all these data and actually attache the functions.
    [ core_functions, media_functions, media_list_functions,
      media_list_player_functions, event_manager_functions].each do |functions|
      functions.each do |symbol, args|
        attach_function symbol, args[0], args[1]
      end
    end
  end
end
