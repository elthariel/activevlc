##
## cli.rb
## Login : <lta@still>
## Started on  Wed Jun 12 14:22:50 2013 Lta Akr
## $Id$
##
## Author(s):
##  - Lta Akr <>
##
## Copyright (C) 2013 Lta Akr

require 'activevlc'
require 'thor'

# Create the CLI module before loading CLI classes.
module ActiveVlc::CLI
end

require 'activevlc/cli/vlc'
require 'activevlc/cli/pipe'



module ActiveVlc
  class Cli < Thor
    package_name "ActiveVlc"

    desc 'version', 'Show current ActiveVlc version'
    def version
      puts "ActiveVlc version #{ActiveVlc::VERSION}"
    end

    desc 'vlc', 'VLC specific commands. See `activevlc vlc` for details'
    subcommand 'vlc', ActiveVlc::CLI::Vlc

    desc 'pipe', 'Pipeline commands. See `activevlc pipe` for details'
    subcommand 'pipe', ActiveVlc::CLI::Pipe
  end
end
