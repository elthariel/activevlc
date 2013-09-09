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

ActiveVlc::Pipeline.for 'input.mp4' do
  gather
  transcode do
    deinterlace
    audio :aac do
      bitrate 128 # 128 kpbs
      channels 2
    end
    video :h264 do
      encoder :x264 do
        bpyramid :strict
        bframes 4
        cabac false
      end
      bitrate 512 # 512 kbps
    end
  end
  duplicate do
    to :file do
      mux :mp4
      dst 'output.mp4'
    end
    to :display
  end
end
