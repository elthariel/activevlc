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



module ActiveVlc
  class Cli < Thor
    package_name "ActiveVlc"

    desc 'version', 'Show current ActiveVlc version'
    def version
      puts "ActiveVlc version #{ActiveVlc::VERSION}"
    end

    desc 'vlc SUBCOMMAND ...ARGS', 'vlc specific commands'
    subcommand 'vlc', ActiveVlc::CLI::Vlc

    desc 'fragment PIPE_PATH', 'Outputs vlc :sout=chain fragment for the pipe defined in \'PIPE_PATH\' file'
    def fragment(path)
      if File.readable?(path)
        pipe = eval(File.read(path))
        puts pipe.fragment
      else
        puts "Error: file [#{path}] doesn't exist or reading permission denied."
        exit 42
      end
    end

    desc 'exec PIPE_PATH', 'Run the PIPE_PATH pipe file in VLC'
    def exec(path)
      if File.readable?(path)
        begin
          pipe = eval(File.read(path))
          fragment = pipe.fragment
        rescue
          puts "Error while parsing pipe file"
          exit 43
        end
        Kernel.exec "cvlc -vvv --play-and-exit #{fragment}"
      else
        puts "Error: file [#{path}] doesn't exist or reading permission denied."
      end
        exit $?.exitstatus
    end

    desc 'dump PIPE_PATH', 'Dump the internal representation of the pipeline defined in the file PIPE_PATH'
    def dump(path)
      if File.readable?(path)
        pipe = eval(File.read(path)).dump
      else
        puts "Error: file [#{path}] doesn't exist or reading permission denied."
        exit 42
      end
    end
  end
end
