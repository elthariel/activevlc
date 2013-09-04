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

require 'activevlc/stage'

module ActiveVlc
  class Pipeline
    ################
    # ClassMethods #
    ################
    class << self
      def parse(path)
        return nil unless File.exists?(path)

        # FIXME I hope to find some cleaner way to do this at some point
        eval(File.open(path).read)
      end

      def for(*inputs, &block)
        puts "Called ActiveVlc::Pipeline.for"
        pipeline = new(inputs)
        DSL::Pipeline.new(pipeline).instance_eval(&block)
        pipeline
      end
    end

    def initialize(array_or_string)
      @inputs = [array_or_string] if array_or_string.is_a? String
      @inputs ||= array_or_string
    end

    def fragment
      @inputs.join ' '
    end

    # Append a Stage in the pipeline
    def <<(stage)
    end
  end
end
