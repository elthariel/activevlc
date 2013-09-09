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
    def audio(codec, &block)
      __option :acodec, codec
      TranscodeAudio.new(@context).instance_eval &block if block_given?
    end
    def video(codec, &block)
      __option :vcodec, codec
      TranscodeVideo.new(@context).instance_eval &block if block_given?
    end
    def subtitle(codec, &block)
      __option :scodec, codec
      TranscodeSubtitle.new(@context).instance_eval &block if block_given?
    end
  end


  # Syntactic sugar classes for different type of streams
  class TranscodeAudio < Base
    def bitrate(val)
      __option :ab, val
    end
    def encoder(val, &block)
      __option :aenc, val, &block
    end
  end

  class TranscodeVideo < Base
    def bitrate(val)
      __option :vb, val
    end
    def encoder(val, &block)
      __option :venc, val, &block
    end
  end

  class TranscodeSubtitle
    def encoder(val, &block)
      __option :senc, val, block
    end
    def filter(val)
      __option :sfilter, val
    end
  end
end
