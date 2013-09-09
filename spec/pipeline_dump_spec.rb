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

describe 'ActiveVlc::PipelineDump' do
  describe 'CLI' do
    it 'needs a pipeline file as paremeter' do
      `bundle exec activevlc dump 2>&1`.should match(/ERROR/)
    end
    it 'needs an existent pipeline file' do
      `bundle exec activevlc dump inexistent.rb`
      $?.exitstatus.should_not eq(0)
    end
  end

  it 'displays a readable dump of the pipeline on STDOUT' do
    dump = <<-DUMP
*** Dumping pipeline internal representation
+ ActiveVlc::Pipeline
  + Input : input.mp4
  + ActiveVlc::Stage::Stream(sout): {}
    + ActiveVlc::Stage::Transcode(transcode): {:acodec=>:aac, :vcodec=>:h264, :scodec=>:svcd}
    + ActiveVlc::Stage::Duplicate(duplicate): {}
      + ActiveVlc::Stage::Base(standard): {"mux"=>:mp4, "dst"=>"output.mp4"}
      + ActiveVlc::Stage::Base(display): {}
DUMP
    `bundle exec activevlc dump spec/pipes/transcode_and_display.rb`.should eq(dump)
  end
end
