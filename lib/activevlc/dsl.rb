##
## dsl.rb
## Login : <lta@still>
## Started on  Wed Jun 12 20:48:40 2013 Lta Akr
## $Id$
##
## Author(s):
##  - Lta Akr <>
##
## Copyright (C) 2013 Lta Akr

require 'activevlc/pipeline'
require 'activevlc/dsl/base'
require 'activevlc/dsl/pipeline'

module ActiveVlc
  def self.pipe_for(*path, &block)
    pipeline = Pipeline.new(path)
    DSL::Pipeline.new(pipeline).instance_eval(&block)
    pipeline
  end
end
