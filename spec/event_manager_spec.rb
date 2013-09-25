require "spec_helper"

describe ActiveVlc::LibVlc::EventManager do
  let(:vlc)    { ActiveVlc::LibVlc::Instance.new [' ', '--play-and-exit'] }
  let(:media)  { vlc.create_media 'file:///tmp/test.mp4' }
  let(:media2) { vlc.create_media '/tmp/test2.mp4' }
  let(:list) do
    l = vlc.create_media_list
    l << media
    l << media2
    l
  end
  let(:player) do
    p = vlc.create_player
    p.media_list = list
    p
  end
  let(:player_event) { player.event_manager }

  it 'can be created' do
    media.event_manager.should be_a_kind_of(ActiveVlc::LibVlc::EventManager)
    list.event_manager.should be_a_kind_of(ActiveVlc::LibVlc::EventManager)
    player.event_manager.should be_a_kind_of(ActiveVlc::LibVlc::EventManager)
  end

  it 'registers and stores callbacks' do
    event1 = ActiveVlc::LibVlc::Api::EventType[:MediaListPlayerStopped]
    event2 = ActiveVlc::LibVlc::EventManager::EventType[:MediaListPlayerPlayed]
    player_event.callbacks.keys.length.should eq(0)
    player_event.on(event1) {}
    player_event.on(event2) {}
    player_event.on(:MediaListPlayerNextItemSet) {}
    # For some reason the 'Played' event is invalid :-/ ...
    player_event.callbacks.keys.length.should eq(2)
    player.play
  end

  it 'receives events' do
    player_event.on(:MediaListPlayerNextItemSet) {}
    player_event.on(:MediaListPlayerStopped) {}
    player.play
    player.stop
    player_event.events_received.should eq(2)
  end
end
