##
## design.rb
## Login : <lta@still>
## Started on  Wed Jun 12 01:18:11 2013 Lta Akr
##
## Author(s):
##  - Julien 'Lta' BALLET <contact@lta.io>
##
## Copyright (C) 2013 Julien 'Lta' BALLET

# This example isn't supposed to work yet. It justs document what it's
# supposed to look like when it's ready

pipe_for 'file.mp4' do |pipe|
  transcode do
    audio do
      codec :aac do
        rc_method :vbr
        psy_model :test1
      end
      bitrate 256
    end
    video :h264 do
      encoder :qsv
      async_depth 6
      h264_level '5.1'
    end
  end
  deinterlace

  duplicate do
    to :dst do
      caching 300
      muxer 'mp4'
      path '/tmp/test.mp4'
    end
    to :rtp do
      caching 1500
      muxer :ts
      dst '192.168.0.1:4567'
    end
    to_display
  end
end



#
# Kind of memory representation of the next pipeline
# Pipeline
#   @stages =
#      - Stage (@type = :transcode)
#        @options = {
#          acodec = {
#            _this_: :aac,
#            opt1:   'test',
#            opt1:   'test',
#          }
#        }
#      - DuplicateStage (@type = :duplicate)
#        @substages =
#          - Stage (@type = :standard)
#            @options = {
#              mux: 'mp4'
#              dst: 'output.mp4'
#            }
#
ActiveVlc::pipe_for 'input.mp4' do
  transcode do
    audio :aac do
      opt1 'test'
      opt2 'caca'
      opt3 42
    end
    video :h264
  end
  duplicate do
    to :file do
      mux :mp4
      dst 'output.mp4'
    end
    to :display
  end
end
