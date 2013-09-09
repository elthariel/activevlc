##
## debug_print.rb
## Login : <lta@still>
## Started on  Fri Sep  6 17:42:31 2013 Lta Akr
## $Id$
##
## Author(s):
##  - Lta Akr <>
##
## Copyright (C) 2013 Lta Akr

require 'debugger'

module ActiveVlc
  module PipelineDump
    extend ActiveSupport::Concern

    TAB_WIDTH = 2

    def _dump(depth = 0)
      name = instance_eval &_find_in_ancestors(:_dump_name)

      puts "#{_dump_depth(depth)}+ #{name}"

      childs = instance_eval &_find_in_ancestors(:_dump_childs)
      childs.each { |c| c._dump(depth + 1) }
    end

    def _dump_depth(depth)
      ' ' * depth * TAB_WIDTH
    end

    # FIXME Find an elegant way to do this :-/
    # Here we walk the ancestor array to find the one which included us first and therefore
    # has a default _dump_name and _dump_childs. It will stops to the first ancestor which has
    # (re)defined it.
    def _find_in_ancestors(sym)
      klass = self.class
      while klass.respond_to?(sym) and klass.superclass and not klass.send(sym)
        klass = klass.superclass
      end
      klass.send(sym)
    end

    included do
      dump_name { self.class.name }
      dump_childs { [] }
    end

    module ClassMethods
      attr_accessor :_dump_name, :_dump_childs

      def dump_name(&block)
        self._dump_name = block
      end

      def dump_childs(&block)
        self._dump_childs = block
      end
    end
  end
end
