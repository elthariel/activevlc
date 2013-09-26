##
## api.rb
## Login : <lta@still>
## Started on  Wed Jun 12 14:45:36 2013 Lta Akr
## $Id$
##
## Author(s):
##  - Lta Akr <>
##
## Copyright (C) 2013 Lta Akr

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
     new:               [[:int, :pointer], :pointer],
     release:           [[:pointer], :void],
     retain:            [[:pointer], :void],
     add_intf:          [[:pointer, :string], :int],
     set_exit_handler:  [[:pointer, :exit_handler, :pointer], :void],
     wait:              [[:pointer], :void],
     set_user_agent:    [[:pointer, :string, :string], :void],
     get_version:       [[], :string],
     get_compiler:      [[], :string],
     free:              [[:pointer], :void]
    }

    #
    # Media functions
    #
    media_functions = {
      media_new_location:     [[:pointer, :string], :pointer],
      media_new_path:         [[:pointer, :string], :pointer],
      media_add_option:       [[:pointer, :string], :void],
      media_add_option_flag:  [[:pointer, :string, :int], :void],
      media_duplicate:        [[:pointer], :pointer],
      media_event_manager:    [[:pointer], :pointer],
      media_retain:           [[:pointer], :void],
      media_release:          [[:pointer], :void],
      media_get_mrl:          [[:pointer], :string]
    }

    #
    # Media List functions
    #
    media_list_functions = {
      media_list_new:             [[:pointer], :pointer],
      media_list_retain:          [[:pointer], :void],
      media_list_release:         [[:pointer], :void],
      media_list_lock:            [[:pointer], :void],
      media_list_unlock:          [[:pointer], :void],
      media_list_event_manager:   [[:pointer], :pointer],
      media_list_set_media:       [[:pointer, :pointer], :void],
      media_list_add_media:       [[:pointer, :pointer], :int],
      media_list_insert_media:    [[:pointer, :pointer, :int], :int],
      media_list_count:           [[:pointer], :int]
    }


    #
    # Media Player functions and type
    #
    PlayerState = enum(:NothingSpecial,
                       :Opening,
                       :Buffering,
                       :Playing,
                       :Paused,
                       :Stopped,
                       :Ended,
                       :Error)

    media_player_functions = {
      media_player_new:             [[:pointer], :pointer],
      media_player_new_from_media:  [[:pointer], :pointer],
      media_player_retain:          [[:pointer], :void],
      media_player_release:         [[:pointer], :void],
      media_player_set_media:       [[:pointer, :pointer], :void],
      media_player_get_media:       [[:pointer], :pointer],
      media_player_event_manager:   [[:pointer], :pointer],
      media_player_is_playing:      [[:pointer], :int],
      media_player_play:            [[:pointer], :int],
      media_player_pause:           [[:pointer], :void],
      media_player_stop:            [[:pointer], :void],
      media_player_get_state:       [[:pointer], PlayerState]
    }

    #
    # Media List Player functions
    #
    media_list_player_functions = {
      media_list_player_new:                [[:pointer], :pointer],
      media_list_player_retain:             [[:pointer], :void],
      media_list_player_release:            [[:pointer], :void],
      media_list_player_event_manager:      [[:pointer], :pointer],
      media_list_player_set_media_list:     [[:pointer, :pointer], :void],
      media_list_player_set_media_player:   [[:pointer, :pointer], :void],
      media_list_player_play:               [[:pointer], :void],
      media_list_player_pause:              [[:pointer], :void],
      media_list_player_stop:               [[:pointer], :void],
      media_list_player_next:               [[:pointer], :void],
      media_list_player_previous:           [[:pointer], :void],
      media_list_player_is_playing:         [[:pointer], :int]
    }

    #
    # Event manager functions and types
    #
    callback :event_handler, [:pointer, :pointer], :void

    EventType = enum(
      :MediaMetaChanged,          0,
      :MediaSubItemAdded,
      :MediaDurationChanged,
      :MediaParsedChanged,
      :MediaFreed,
      :MediaStateChanged,

      :MediaPlayerMediaChanged,   0x100,
      :MediaPlayerNothingSpecial,
      :MediaPlayerOpening,
      :MediaPlayerBuffering,
      :MediaPlayerPlaying,
      :MediaPlayerPaused,
      :MediaPlayerStopped,
      :MediaPlayerForward,
      :MediaPlayerBackward,
      :MediaPlayerEndReached,
      :MediaPlayerEncounteredError,
      :MediaPlayerTimeChanged,
      :MediaPlayerPositionChanged,
      :MediaPlayerSeekableChanged,
      :MediaPlayerPausableChanged,
      :MediaPlayerTitleChanged,
      :MediaPlayerSnapshotTaken,
      :MediaPlayerLengthChanged,
      :MediaPlayerVout,

      :MediaListItemAdded,        0x200,
      :MediaListWillAddItem,
      :MediaListItemDeleted,
      :MediaListWillDeleteItem,

      :MediaListViewItemAdded,    0x300,
      :MediaListViewWillAddItem,
      :MediaListViewItemDeleted,
      :MediaListViewWillDeleteItem,

      :MediaListPlayerPlayed,     0x400,
      :MediaListPlayerNextItemSet,
      :MediaListPlayerStopped,

      :MediaDiscovererStarted,    0x500,
      :MediaDiscovererEnded,

      :VlmMediaAdded,             0x600,
      :VlmMediaRemoved,
      :VlmMediaChanged,
      :VlmMediaInstanceStarted,
      :VlmMediaInstanceStopped,
      :VlmMediaInstanceStatusInit,
      :VlmMediaInstanceStatusOpening,
      :VlmMediaInstanceStatusPlaying,
      :VlmMediaInstanceStatusPause,
      :VlmMediaInstanceStatusEnd,
      :VlmMediaInstanceStatusError
      )

    event_manager_functions = {
      event_attach:     [[:pointer, EventType, :event_handler, :pointer], :int],
      event_detach:     [[:pointer, EventType, :event_handler, :pointer], :void],
      event_type_name:  [[:int], :string]
    }

    # Here we use all these data and actually attache the functions.
    [ core_functions, media_functions, media_list_functions, media_player_functions,
      media_list_player_functions, event_manager_functions].each do |functions|
      functions.each do |symbol, args|
        attach_function "libvlc_#{symbol}".to_sym, args[0], args[1]
      end
    end
  end
end
