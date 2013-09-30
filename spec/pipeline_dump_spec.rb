##
## pipeline_dump_spec.rb
## Login : <lta@still>
## Started on  Mon Sep  9 12:31:23 2013 Lta Akr
## $Id$
##
## Author(s):
##  - Lta Akr <>
##
## Copyright (C) 2013 Lta Akr

require 'spec_helper'

describe 'ActiveVlc::PipelineDump' do
  describe 'CLI' do
    it 'needs a pipeline file as paremeter' do
      `bundle exec activevlc pipe dump 2>&1`.should match(/ERROR/)
    end
    it 'needs an existent pipeline file' do
      `bundle exec activevlc pipe dump inexistent.rb`
      $?.exitstatus.should_not eq(0)
    end
  end

  it 'return a readable representation of the pipeline' do
    dump = <<-DUMP
ActiveVlc: Dumping pipeline internal representation
+ ActiveVlc::Pipeline
  + Input : input.mp4
  + ActiveVlc::Stage::Stream(sout): {}
    + ActiveVlc::Stage::Transcode(transcode): {:acodec=>:aac, :vcodec=>:h264, :scodec=>:svcd}
    + ActiveVlc::Stage::Duplicate(duplicate): {}
      + ActiveVlc::Stage::Base(standard): {"mux"=>:mp4, "dst"=>"output.mp4"}
      + ActiveVlc::Stage::Base(display): {}
DUMP
    ActiveVlc::Pipeline.parse('spec/pipes/transcode_and_display.rb').dump.should eq(dump)
  end
end
