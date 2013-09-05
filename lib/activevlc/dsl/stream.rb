##
## stream.rb
## Login : <lta@still>
## Started on  Thu Sep  5 11:13:44 2013 Lta Akr
## $Id$
##
## Author(s):
##  - Lta Akr <>
##
## Copyright (C) 2013 Lta Akr

module ActiveVlc::DSL
  class Stream < Base
    def duplicate(&block)
      dup = ActiveVlc::Stage::Duplicate.new
      @context << dup
      ActiveVlc::DSL::Stream.new(dup).instance_eval(&block)
      self
    end

    def to(sym_or_hash, &block)
      if sym_or_hash.is_a?(Hash)
        type, opt = sym_or_hash.first
      else
        type, opt = [sym_or_hash, nil]
      end

      type = :standard if type == :file

      stage = ActiveVlc::Stage::Base.new(type)
      stage[:dst]= opt if type == :standard and opt

      @context << stage
    end

    alias :dup :duplicate
  end
end
