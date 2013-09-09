##
## duplicate.rb
## Login : <lta@still>
## Started on  Thu Sep  5 10:15:03 2013 Lta Akr
## $Id$
##
## Author(s):
##  - Lta Akr <>
##
## Copyright (C) 2013 Lta Akr

require 'activevlc/stage/base'

module ActiveVlc::Stage
  class Duplicate < Base
    attr_reader :stages

    dump_childs { @stages }

    def initialize()
      super(:duplicate)
      @stages = []
    end

    def <<(stage)
      @stages.push stage
      @stages.flatten!
      self
    end

    def fragment
      f = @stages.map do |s|
        "dst=#{s.fragment}"
      end.join ', '
      "duplicate{#{f}}"
    end
  end
end
