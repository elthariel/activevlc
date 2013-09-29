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

    desc 'vlc ', 'VLC specific commands. See activevlc help vlc for details'
    subcommand 'vlc', ActiveVlc::CLI::Vlc

    desc 'fragment path', 'Outputs vlc \':sout=...\' string for the pipeline defined in the \'path\' file'
    def fragment(path)
      if File.readable?(path)
        pipe = eval(File.read(path))
        puts pipe.fragment
      else
        puts "Error: file [#{path}] doesn't exist or reading permission denied."
        exit 42
      end
    end

    desc 'exec path [input_file_1 [input_file_2] [...]]', 'Launch vlc executable to run the pipeline described in path file'
    option :cmd, type: :boolean, default: false
    def exec(path, *inputs)
      if File.readable?(path)
        begin
          pipe = ActiveVlc::parse(path)
          pipe.input << inputs
          fragment = pipe.fragment
        rescue
          puts "Error while parsing pipe file: #{$!}"
          exit 43
        end
        if options[:cmd]
          Kernel.exec "vlc -I dummy -vvv --play-and-exit #{fragment}"
        else
          ActiveVlc::Runner.new(pipe).run
        end
      else
        puts "Error: file [#{path}] doesn't exist or reading permission denied."
      end
        exit $?.exitstatus
    end

    desc 'dump path', 'Dump the internal representation of the pipeline defined in the file path'
    def dump(path)
      if File.readable?(path)
        puts eval(File.read(path)).dump
      else
        puts "Error: file [#{path}] doesn't exist or reading permission denied."
        exit 42
      end
    end
  end
end
