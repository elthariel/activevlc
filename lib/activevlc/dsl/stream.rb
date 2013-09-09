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
    # FIXME refactor more DRY
    def method_missing(sym, *args, &block)
      begin
        klass = ActiveVlc::Stage.const_get sym.to_s.capitalize.to_sym
      rescue
        klass = ActiveVlc::Stage::Base
        args.unshift(sym)
      end

      begin
        dsl_klass = ActiveVlc::DSL.const_get sym.to_s.capitalize.to_sym
      rescue
        dsl_klass = ActiveVlc::DSL::Base
      end

      add_substage(klass, dsl_klass, *args, &block)
    end

    # FIXME This method contains some dirty syntactic sugar as a PoC and need refactor
    def to(sym_or_hash, &block)
      if sym_or_hash.is_a?(Hash)
        type, opt = sym_or_hash.first
      else
        type, opt = [sym_or_hash, nil]
      end

      type = :standard if type == :file

      stage = ActiveVlc::Stage::Base.new(type)
      stage[:dst]= opt if type == :standard and opt

      # Evaluate against the DSL if a block is given
      ActiveVlc::DSL::Base.new(stage).instance_eval(&block) if block_given?

      @context << stage
    end

    protected
    def add_substage(stage_klass, dsl_klass, *args, &block)
      stage = stage_klass.new(*args)
      @context << stage
      dsl = dsl_klass.new(stage)
      dsl.instance_eval &block if block_given?
    end
  end
end
