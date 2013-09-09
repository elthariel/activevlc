##
## stream_stage.rb
## Login : <lta@still>
## Started on  Wed Sep  4 19:35:50 2013 Lta Akr
## $Id$
##
## Author(s):
##  - Lta Akr <>
##
## Copyright (C) 2013 Lta Akr

module ActiveVlc::Stage
  class Stream < Base
    dump_childs { @chain }

    def initialize
      super :sout
      @chain = []
    end

    def <<(stage)
      @chain.push stage
      @chain.flatten!
      self
    end

    def fragment
      return "" if @chain.empty?
      sout_string = @chain.map{|s| s.fragment}.join ':'
      ":sout=\"##{sout_string}\""
    end
  end
end
