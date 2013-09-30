##
## pipeline_spec.rb
## Login : <lta@still>
## Started on  Wed Jul  3 15:57:47 2013 Lta Akr
## $Id$
##
## Author(s):
##  - Lta Akr <>
##
## Copyright (C) 2013 Lta Akr

require 'spec_helper'

describe ActiveVlc::Pipeline do
  describe "CLI" do
    it 'can ouput fragment with provided inputs' do
      `bundle exec activevlc pipe fragment spec/pipes/no_input.rb input.mp4 input2.mp4`
        .should eq("input.mp4 input2.mp4 :sout=\"#transcode{acodec=vorbis}:standard{mux=ogg, dst='output.ogg'}\"\n")
    end
  end

  describe '\'basic\' pipeline' do
    it 'returns nil if the file doesn\'t exists' do
      ActiveVlc::Pipeline.parse('dontexist.rb').should be_nil
    end

    it 'is loaded' do
      pipe = ActiveVlc::Pipeline.parse 'spec/pipes/basic.rb'
      pipe.class.should be(ActiveVlc::Pipeline)
    end

    it 'can produces a basic fragment' do
      pipe = ActiveVlc::Pipeline.parse 'spec/pipes/basic.rb'
      pipe.fragment.should match(/input.mp4/)
    end

    it 'allows adding new inputs' do
      pipe = ActiveVlc::Pipeline.parse 'spec/pipes/basic.rb'
      pipe.input << 'test.mp3'
      pipe.fragment.should match(/input.mp4/)
      pipe.fragment.should match(/test.mp3/)
    end
  end

  describe '\'duplicate\' pipeline' do
    it 'is loaded' do
      ActiveVlc::Pipeline.parse('spec/pipes/duplicate.rb').class.should be(ActiveVlc::Pipeline)
    end

    it 'produce the correct fragment' do
      expect(ActiveVlc::Pipeline.parse('spec/pipes/duplicate.rb').fragment)
        .to eq("input.mp3 :sout=\"#duplicate{dst=display, dst=standard{dst='output.mp3'}}\"")
    end
  end

  describe '\'transcode_and_display\' pipeline' do
    it 'is loaded' do
      ActiveVlc::Pipeline.parse('spec/pipes/transcode_and_display.rb').class.should be(ActiveVlc::Pipeline)
    end

    it 'produce the correct fragment' do
      expect(ActiveVlc::Pipeline.parse('spec/pipes/transcode_and_display.rb').fragment)
        .to eq("input.mp4 :sout=\"#transcode{acodec=aac, vcodec=h264, scodec=svcd}:duplicate{dst=standard{mux=mp4, dst='output.mp4'}, dst=display}\"")
    end
  end

  describe '\'transcode_and_display_with_options\' pipeline' do
    it 'is loaded' do
      ActiveVlc::Pipeline.parse('spec/pipes/transcode_and_display_with_options.rb').class
        .should be(ActiveVlc::Pipeline)
    end

    it 'produce the correct fragment' do
      expect(ActiveVlc::Pipeline.parse('spec/pipes/transcode_and_display_with_options.rb').fragment)
        .to eq("input.mp4 :sout=\"#gather:transcode{deinterlace, acodec=aac, ab=128, channels=2, vcodec=h264, venc=x264{bpyramid=strict, bframes=4, no-cabac}, vb=512}:duplicate{dst=standard{mux=mp4, dst='output.mp4'}, dst=display}\"")
    end
  end

  describe '\'duplicate_then_transcode\' pipeline' do
    it 'is loaded' do
      ActiveVlc::Pipeline::parse('spec/pipes/duplicate_then_transcode.rb').class
        .should be(ActiveVlc::Pipeline)
    end

    it 'produce the correct fragment' do
      expect(ActiveVlc::Pipeline.parse('spec/pipes/duplicate_then_transcode.rb').fragment)
        .to eq("input.mp4 :sout=\"#duplicate{dst=transcode{acodec=aac, vcodec=h264, scodec=svcd}:standard{mux=mp4, dst='output.mp4'}, dst=display}\"")
    end
  end

  describe '\'no_input\' pipeline' do
    it "is loaded" do
      ActiveVlc::parse('spec/pipes/no_input.rb').class
        .should be(ActiveVlc::Pipeline)
    end

    it 'produce the correct fragment' do
      expect(ActiveVlc::parse('spec/pipes/no_input.rb').fragment)
        .to eq(" :sout=\"#transcode{acodec=vorbis}:standard{mux=ogg, dst='output.ogg'}\"")
    end

    it 'can be assigned inputs' do
      pipe = ActiveVlc::parse('spec/pipes/no_input.rb')
      pipe.input << "input.mp4"
      pipe.input << "input2.mp4"
      pipe.fragment.should eq("input.mp4 input2.mp4 :sout=\"#transcode{acodec=vorbis}:standard{mux=ogg, dst='output.ogg'}\"")
    end
  end

end
