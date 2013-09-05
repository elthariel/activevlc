##
## input_stage.rb
## Login : <lta@still>
## Started on  Wed Sep  4 19:13:47 2013 Lta Akr
## $Id$
##
## Author(s):
##  - Lta Akr <>
##
## Copyright (C) 2013 Lta Akr

require 'activevlc/stage'

module ActiveVlc::Stage
  class Input < Base
    attr_reader :inputs

    def initialize(array_or_string)
      super(:input)

      @inputs = [array_or_string] if array_or_string.is_a? String
      @inputs ||= array_or_string
    end

    def <<(new_inputs)
      @inputs.push new_inputs
      @inputs.flatten!
      self
    end

    def fragment
      @inputs.join ' '
    end
  end
end

