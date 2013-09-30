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

    # See Parametric#visit
    def visit(params)
      super params
      @chain.each { |c| c.visit(params) }
    end
    # See Parametric#has_empty_param?
    def has_missing_parameter?
      @chain.reduce(super) { |accu, substage| accu or substage.has_missing_parameter? }
    end

    def fragment
      return "" if @chain.empty?
      sout_string = @chain.map{|s| s.fragment}.join ':'
      res = ":sout=\"##{sout_string}\""
    end
  end
end
