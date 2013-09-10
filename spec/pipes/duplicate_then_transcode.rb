##
## duplicate_then_transcode.rb
## Login : <lta@still>
## Started on  Tue Sep 10 18:30:41 2013 Lta Akr
## $Id$
##
## Author(s):
##  - Lta Akr <>
##
## Copyright (C) 2013 Lta Akr

ActiveVlc::Pipeline.for 'input.mp4' do
  duplicate do
    to :chain do
      #debugger
      transcode do
        audio :aac
        video :h264
        subtitle :svcd
      end
      to :file do
        mux :mp4
        dst 'output.mp4'
      end
    end
    to :display
  end
end

