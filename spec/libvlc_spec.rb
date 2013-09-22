
require 'spec_helper'

describe ActiveVlc::LibVlc do
  describe "Low-level binding" do
    it 'binds C functions' do
      [ :new, :release, :retain, :add_intf, :wait, :set_user_agent,
        :get_version, :get_compiler, :free, :set_exit_handler ].each do |sym|
          ActiveVlc::LibVlc::Core.respond_to?("libvlc_#{sym}")
            .should be_true
        end
    end

    it 'create a libvlc instance' do
      vlc = ActiveVlc::LibVlc::Core.libvlc_new(0, nil)
      vlc.null?.should be_false
    end

    it 'reports libvlc version' do
      ActiveVlc::LibVlc::Core.libvlc_get_version.should match(/\d\.\d+\.\d+/)
    end
  end

  describe 'Ruby wrapper: Instance' do
    it 'can creates an instance' do
      args = ['-vvv', '--play-and-exit']
      vlc = ActiveVlc::LibVlc::Instance.new args
    end
  end
end
