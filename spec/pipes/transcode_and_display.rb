##
## transcode_and_display.rb
## Login : <lta@still>
## Started on  Wed Jun 12 14:45:36 2013 Lta Akr
## $Id$
##
## Author(s):
##  - Lta Akr <>
##
## Copyright (C) 2013 Lta Akr

ActiveVlc::pipe_for 'input.mp4' do
  transcode do
    audio :aac
    video :h264
    subtitle :svcd
  end
  duplicate do
    to :file do
      mux :mp4
      dst 'output.mp4'
    end
    to :display
  end
end
