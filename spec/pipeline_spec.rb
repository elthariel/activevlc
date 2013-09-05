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

    it 'produce a valid fragment' do
      expect(ActiveVlc::Pipeline.parse('spec/pipes/duplicate.rb').fragment)
        .to eq("input.mp3 :sout=\"#duplicate{dst=display, dst=standard{dst='output.mp3'}}\"")
    end
  end
end
