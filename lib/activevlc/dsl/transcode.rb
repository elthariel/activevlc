##
## transcode.rb
## Login : <lta@still>
## Started on  Fri Sep  6 16:04:12 2013 Lta Akr
## $Id$
##
## Author(s):
##  - Lta Akr <>
##
## Copyright (C) 2013 Lta Akr

module ActiveVlc::DSL
  class Transcode < Base
    def audio(codec)
      __option :acodec, codec
    end
    def video(codec)
      __option :vcodec, codec
    end
  end
end
