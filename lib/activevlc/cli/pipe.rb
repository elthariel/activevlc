
module ActiveVlc::CLI
  class Pipe < Thor
    class_option(:params, type: :hash,
      desc: "Provides a set of named parameter to this pipeline. Example: --params=output:test.mp4 channels:2")

    desc 'fragment path [input_1 [input_2] [...]]', 'Outputs vlc \':sout=...\' string for the pipeline defined in the \'path\' file'
    def fragment(path, *inputs)
      _load_pipe(path, *inputs) { |pipe| puts pipe.fragment }
    end

    desc 'exec path [input_1 [input_2] [...]]', 'Launch vlc executable to run the pipeline described in path file'
    option :cmd, type: :boolean, default: false
    def exec(path, *inputs)
      _load_pipe(path, *inputs) do |pipe|
        fragment = pipe.fragment
        if options[:cmd]
          Kernel.exec "vlc -I dummy -vvv #{fragment} vlc://quit"
        else
          ActiveVlc::Runner.new(pipe).run
        end
      end

    end

    desc 'dump path [inputs]', 'Dump the internal representation of the pipeline defined in the file path'
    def dump(path, *inputs)
      _load_pipe(path, *inputs) { |pipe| pipe.dump }
    end

    desc 'test', 'test'
    option :test, type: :hash
    def test
      puts options.inspect
    end

    protected
    def _load_pipe(path, *inputs)
      if File.readable?(path)
        begin
          pipe = eval(File.read(path))
          pipe.input << inputs
          pipe.params(options[:params]) if options[:params]
          yield pipe if block_given?
        rescue
          puts "Error while parsing pipe file: #{$!}"
          puts $!.backtrace.join("\n")
          exit 43
        end
      else
        puts "Error: file [#{path}] doesn't exist or reading permission denied."
        exit 42
      end
    end
  end
end
