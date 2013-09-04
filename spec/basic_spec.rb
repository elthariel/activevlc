##
## basic.rb
## Login : <lta@still>
## Started on  Wed Jun 12 14:08:35 2013 Lta Akr
## $Id$
##
## Author(s):
##  - Lta Akr <>
##
## Copyright (C) 2013 Lta Akr

require 'spec_helper'

describe ActiveVlc do
  it 'has a version' do
    ActiveVlc::VERSION.is_a?(String).should be_true
  end

  describe 'cmd' do
    it 'return version number on \'version\' command' do
      expect(`bundle exec activevlc version`).to match(/version \d+\.\d+\.\d+/)
      expect(`bundle exec activevlc version`).to match(ActiveVlc::VERSION)
    end
  end

  describe 'VLC detection' do
    it 'detects and returns VLV version number on \'vlc version\'' do
      expect(`bundle exec activevlc vlc version`).to match(/VLC version \d+\.\d+\.\d+/)
    end

    it 'tells if detected VLC version is supported on \'vlc version\'' do
      expect(`bundle exec activevlc vlc version`).to match(/supported = (true|false)/)
    end

    it 'tells if detected VLC version is supported on \'vlc supported\'' do
      expect(`bundle exec activevlc vlc supported`).to match(/(true|false)/)
    end
  end
end

