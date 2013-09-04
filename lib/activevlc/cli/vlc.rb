##
## version.rb
## Login : <lta@still>
## Started on  Wed Sep  4 15:44:38 2013 Lta Akr
## $Id$
##
## Author(s):
##  - Lta Akr <>
##
## Copyright (C) 2013 Lta Akr

module ActiveVlc::CLI
  class Vlc < Thor
    desc 'version', 'reports currently found VLC version and if it is supported'
    def version
      v = _version
      if v
        puts "VLC version #{v[0]}.#{v[1]}.#{v[2]} (supported = #{_supported})"
      else
        puts "vlc binary NOT FOUND (probably not in $PATH)"
      end
    end


    desc 'supported', 'returns whether the found vlc version is supported or not'
    def supported
      puts _supported
    end

    private
    def _version
      version_string = `vlc --version 2>&1`
      if version_string =~ /version (\d+)\.(\d)+\.(\d)+/
        [$1, $2, $3].map &:to_i
      else
        nil
      end
    end

    def _supported
      v = _version
      v and v[0] == 2
    end
  end
end
