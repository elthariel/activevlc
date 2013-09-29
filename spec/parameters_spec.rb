
require 'spec_helper'

describe "Named parameters" do
  pending "Handle named parameter support in PipelineDump"

  let(:pipe) do
    path = 'spec/pipes/transcode_and_display_with_params.rb'
    ActiveVlc::Pipeline.parse path
  end

  it 'can be defined with "p" and "param" keywords in DSL' do
    pipe.should be_a_kind_of(ActiveVlc::Pipeline)
  end

  it '#has_missing_parameter?' do
    pipe.has_missing_parameter?.should be_true
  end

  it 'missing are reported in the fragment' do
    pipe.fragment.should match(/value for outfile not set/)
  end

  it "can be set" do
    pipe.params audio_bitrate: 44100, audio_channels: 2
    pipe.has_missing_parameter?.should be_true
    pipe.params outfile: 'test.pwet'
    pipe.has_missing_parameter?.should be_false
    pipe.fragment.should_not match(/value for .+ not set/)
  end

  it "are generated correctly in fragment" do
    pipe.params audio_bitrate: 44100, audio_channels: 2, outfile: 'file.ext'
    pipe.fragment.should eq(" :sout=\"#transcode{acodec=aac, ab=44100, channels=2}:standard{mux=mp4, dst=file.ext}\"")
  end
end
