##
## libvlc.rb
## Login : <lta@still>
## Started on  Wed Jun 12 20:46:52 2013 Lta Akr
## $Id$
##
## Author(s):
##  - Lta Akr <>
##
## Copyright (C) 2013 Lta Akr

require "ffi"

module ActiveVlc
  module LibVlc
    VLC_SO_NAMES = [
      'libvlc'.freeze,
      'libvlc.so.5'.freeze
      ].freeze
    VLCCORE_SO_NAMES = [
      'libvlccore'.freeze,
      'libvlccore.so.5'.freeze
      ].freeze
  end
end

require 'activevlc/libvlc/api'
require 'activevlc/libvlc/media'
require 'activevlc/libvlc/instance'
require 'activevlc/libvlc/media_list'
require 'activevlc/libvlc/media_list_player'
require 'activevlc/libvlc/event_manager'
