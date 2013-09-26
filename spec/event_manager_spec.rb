require "spec_helper"

describe ActiveVlc::LibVlc::EventManager do
  let(:vlc)    { ActiveVlc::LibVlc::Instance.new [' ', '--play-and-exit'] }
  let(:media)  { vlc.create_media 'file:///tmp/test.mp4' }
  let(:media2) { vlc.create_media '/tmp/test2.mp4' }
  let(:player) { vlc.create_player }
  let(:list) do
    l = vlc.create_media_list
    l << media
    l << media2
    l
  end
  let(:list_player) do
    lp = vlc.create_list_player
    lp.media_list = list
    lp
  end
  let(:player_event)      { player.event_manager }
  let(:list_player_event) { list_player.event_manager }

  it 'can be created' do
    media.event_manager.should be_a_kind_of(ActiveVlc::LibVlc::EventManager)
    list.event_manager.should be_a_kind_of(ActiveVlc::LibVlc::EventManager)
    player.event_manager.should be_a_kind_of(ActiveVlc::LibVlc::EventManager)
    list_player.event_manager.should be_a_kind_of(ActiveVlc::LibVlc::EventManager)
  end

  it 'registers and stores callbacks' do
    event1 = ActiveVlc::LibVlc::Api::EventType[:MediaListPlayerStopped]
    event2 = ActiveVlc::LibVlc::EventManager::EventType[:MediaListPlayerPlayed]
    list_player_event.callbacks.keys.length.should eq(0)
    list_player_event.on(event1) {}
    list_player_event.on(event2) {}
    list_player_event.on(:MediaListPlayerNextItemSet) {}
    # For some reason the 'Played' event is invalid :-/ ...
    list_player_event.callbacks.keys.length.should eq(2)
    list_player.play
  end

  it 'MediaPlayer\'s EventManger receives events' do
    first_event = ActiveVlc::LibVlc::Api::EventType[:MediaPlayerMediaChanged]
    last_event = ActiveVlc::LibVlc::Api::EventType[:MediaPlayerVout]
    (first_event..last_event).to_a.each { |e| player_event.on(e) {} }
    player.media = media
    player_event.events_received.should eq(1)
    player.play
    sleep 0.25 # Avoid random deadlock in vlc :-/ and gives some time for vlc to run
    player.stop
    player_event.events_received.should eq(5)
  end

  it 'MediaListPlayer\'s EventManger receives events' do
    list_player_event.on(:MediaListPlayerNextItemSet) {}
    list_player_event.on(:MediaListPlayerStopped) {}
    list_player.play
    list_player.stop
    list_player_event.events_received.should eq(2)
  end

  it 'calls registered callback' do
    @cbk1_called = false
    @cbk2_called = false
    list_player_event.on(:MediaListPlayerNextItemSet) { @cbk1_called = true }
    list_player_event.on(:MediaListPlayerStopped) { @cbk2_called = true }
    list_player.play
    list_player.stop
    @cbk1_called.should be_true
    @cbk2_called.should be_true
  end

  it 'MediaPlayer receives event when assigned as MediaListPlayer\' player' do
    first_event = ActiveVlc::LibVlc::Api::EventType[:MediaPlayerMediaChanged]
    last_event = ActiveVlc::LibVlc::Api::EventType[:MediaPlayerVout]
    (first_event..last_event).to_a.each { |e| player_event.on(e) {} }
    list_player.player = player
    list_player.play
    sleep 0.25
    list_player.stop
    player_event.events_received.should eq(5)
  end

end
