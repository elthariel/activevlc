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

    def method_missing(sym, *args, &unused)
      __option(normalize_option(sym), args.first)
    end

    protected
    def normalize_option(name) name.to_s.downcase.gsub('_', '-') end

    def __option(name, value)
      @context[name] = value
    end
  end
end
