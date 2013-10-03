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
    include ActiveVlc::Parametric
    dump_name { "#{self.class.name}(#{@type}): #{options}" }

    attr_reader :type
    # Options represents vlc's sout options
    attr_reader :options

    def initialize(type = :dummy, opts = {})
      super() # ActiveVlc::Parametric
      @options = Hash.new.merge opts
      @type = type
    end

    def [](key) @options[key] end
    def []=(key, value) @options[key] = value end

    def fragment
      render_fragment(@type, @options)
    end

    protected
    # Handles the rendering of the options hash to a vlc sout format
    #
    def render_fragment(k, h)
      map = h.map do |key, value|
        if value.nil?
          "#{key}"
        elsif value == false
          "no-#{key}"
        elsif value.is_a?(Base) and not value.type
          "#{key}#{format_value value}"
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
      if value.is_a? Base
        "#{value.fragment}"
      elsif value.is_a? String
        "'#{value}'"
      else
        "#{value}"
      end
    end

  end
end
