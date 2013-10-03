##
## base.rb
## Login : <lta@still>
## Started on  Wed Jun 12 20:59:51 2013 Lta Akr
## $Id$
##
## Author(s):
##  - Lta Akr <>
##
## Copyright (C) 2013 Lta Akr

module ActiveVlc::DSL
  class Base
    def initialize(context)
      @context = context
    end

    def method_missing(sym, *args, &block)
      __option(normalize_option(sym), args.first, &block)
    end

    def param(name, value = nil)
      if @context.parameters.has_param? name
        @context.parameters[name]
      else
        @context.parameters[name] = ActiveVlc::Parameter.new(name, value)
      end
    end
    alias :p :param

    protected
    def normalize_option(name) name.to_s.downcase.gsub('_', '-') end

    def __option(name, value, &block)
      if block_given?
        subcontext = ActiveVlc::Stage::Base.new(value)
        Base.new(subcontext).instance_eval &block
        @context[name] = subcontext
      else
        @context[name] = value
      end
    end
  end
end
