##
## pipeline.rb
## Login : <lta@still>
## Started on  Wed Jun 12 21:00:28 2013 Lta Akr
## $Id$
##
## Author(s):
##  - Lta Akr <>
##
## Copyright (C) 2013 Lta Akr

module ActiveVlc::DSL
  module Pipeline
    extend ActiveSupport::Concern

    module ClassMethods
      def parse(path)
        return nil unless File.exists?(path)

        # FIXME I hope to find some cleaner way to do this at some point
        eval(File.open(path).read)
      end

      def for(*inputs, &block)
        pipeline = new(inputs)
        ::ActiveVlc::DSL::Stream.new(pipeline.sout).instance_eval(&block) if block_given?
        pipeline
      end
    end
  end
end
