##
## base.rb
## Login : <lta@still>
## Started on  Thu Sep  5 10:08:46 2013 Lta Akr
## $Id$
##
## Author(s):
##  - Lta Akr <>
##
## Copyright (C) 2013 Lta Akr

# Represents a stage in the pipeline
module ActiveVlc::Stage
  class Base
    include ActiveVlc::PipelineDump
    dump_name { "#{self.class.name}(#{@type}): #{options}" }

    attr_reader :type
    attr_reader :options

    def initialize(type = :dummy)
      @options = Hash.new
      @type = type
    end

    def [](key) @options[key] end
    def []=(key, value) @options[key] = value end

    def fragment
      _recurse_on_suboption(@type, @options)
    end

    protected
    # Handles the rendering of the options hash to a vlc sout format
    #
    # key = vlc, value = {test: 42, sub: {_this_: 'this', opt1='foo'}, sub2: {opt2: 'bar'}}
    # renders to "key{test=42,sub=this{opt1=foo},sub2{opt2:bar}}"
    def _recurse_on_suboption(k, h)
      map = h.map do |key, value|
        if value.is_a?(Hash)
          value_without_this = value.clone
          this = value_without_this.delete :_this_
          if this
            "#{key}=#{_recurse_on_suboption(this, value_without_this)}"
          else
            _recurse_on_suboption(key, value)
          end
        else
          "#{key}=#{format_value value}"
        end
      end.join(', ')

      if map == ""
        "#{k}"
      else
        "#{k}{#{map}}"
      end
    end

    def format_value(value)
      if value.is_a? String
        "'#{value}'"
      else
        "#{value}"
      end
    end

  end
end
