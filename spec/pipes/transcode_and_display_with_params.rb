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

ActiveVlc::pipe do
  transcode do
    audio :aac do
      bitrate param(:audio_bitrate)
      channels p(:audio_channels)
    end
  end
  to :file do
    mux :mp4
    dst p(:outfile)
  end
end
