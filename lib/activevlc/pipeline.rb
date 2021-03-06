##
## pipeline.rb
## Login : <lta@still>
## Started on  Wed Jun 12 20:46:52 2013 Lta Akr
## $Id$
##
## Author(s):
##  - Lta Akr <>
##
## Copyright (C) 2013 Lta Akr

require 'activevlc/pipeline_dump'
require 'activevlc/stage'
require 'activevlc/dsl/pipeline'

module ActiveVlc
  class Pipeline
    include DSL::Pipeline
    include PipelineDump
    include Parametric

    attr_reader :input, :sout

    def initialize(input_array_or_string = nil, &block)
      super()
      @input = Stage::Input.new(input_array_or_string)
      @sout = Stage::Stream.new # SOut = Stream Out

      ::ActiveVlc::DSL::Stream.new(@sout).instance_eval(&block) if block_given?
    end

    def fragment
      [@input.fragment, @sout.fragment].join ' '
    end

    def visit(params)
      @parameters.merge!(params)
      @sout.visit(@parameters)
    end
    alias :params :visit
    def has_missing_parameter?
      @sout.has_missing_parameter?
    end

    dump_childs { [input, sout] }
    def dump
      "ActiveVlc: Dumping pipeline internal representation\n" + _dump
    end
  end
end
