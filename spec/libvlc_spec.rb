
require 'spec_helper'

describe ActiveVlc::LibVlc do
  describe "Low-level binding" do
    it 'binds C functions' do
      [ :new, :release, :retain, :add_intf, :wait, :set_user_agent,
        :get_version, :get_compiler, :free, :set_exit_handler ].each do |sym|
          ActiveVlc::LibVlc::Api.respond_to?("libvlc_#{sym}")
            .should be_true
        end
    end

    it 'create a libvlc instance' do
      vlc = ActiveVlc::LibVlc::Api.libvlc_new(0, nil)
      vlc.null?.should be_false
    end

    it 'reports libvlc version' do
      ActiveVlc::LibVlc::Api.libvlc_get_version.should match(/\d\.\d+\.\d+/)
      ActiveVlc::LibVlc.version.should match(/\d\.\d+\.\d+/)
      ActiveVlc::LibVlc.compiler.should match(/\d\.\d+\.\d+/)
    end
  end

  describe 'Ruby wrapper: Instance/MediaXXX/EventManger creation' do
    let(:vlc)    { ActiveVlc::LibVlc::Instance.new [' ', '--play-and-exit'] }
    let(:media)  { vlc.create_media 'file:///tmp/test.mp4' }
    let(:media2) { vlc.create_media '/tmp/test2.mp4' }
    let(:list)   { vlc.create_media_list }
    let(:player) { vlc.create_player }

    it 'can creates an instance' do
      vlc.should be_a_kind_of(ActiveVlc::LibVlc::Instance)
      vlc.ptr.null?.should be_false
    end

    it 'can creates a Media from an Instance using an MRL' do
      media.should be_a_kind_of(ActiveVlc::LibVlc::Media)
      media.ptr.null?.should be_false
    end

    it 'can creates a Media from an Instance using a path' do
      media_from_path = vlc.create_media('/tmp/pwet')
      media_from_path.should be_a_kind_of(ActiveVlc::LibVlc::Media)
      media_from_path.ptr.null?.should be_false
    end

    it 'can set an option on a Media' do
      media << ":sout='#display'"
      expect { media << 42 }.to raise_error
    end

    it 'can creates a MediaList from an Instance' do
      list.should be_a_kind_of(ActiveVlc::LibVlc::MediaList)
      list.ptr.null?.should be_false
    end

    it 'allows setting media of a media list' do
      list << media2
      list.media = media
      list.length.should eq(1)
    end

    it 'allows adding media to a MediaList' do
      list << media
      list << media2
      list.length.should eq(2)
    end

    it 'allows the creation of a MediaListPlayer' do
      player.should be_a_kind_of(ActiveVlc::LibVlc::MediaListPlayer)
      player.ptr.null?.should be_false
      list << media
      player.media_list = list
      expect {player.media_list = nil}.to raise_error
    end
  end
end
