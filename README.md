# ActiveVlc

[![Gem Version](https://badge.fury.io/rb/activevlc.png)](http://badge.fury.io/rb/activevlc)

Do you know VLC, the famous media player ? I'm pretty sure you do !
Do you know this is also a pretty powerfull media processing and streaming framework ? Maybe...
Do you understand something about the command line syntax to access vlc's underlying
powers ? If you don't this tool is for you !

ActiveVlc provides a simple syntax to configure and run transcoding/streaming/processing
operations using VLC. Here's a simple example :

## Installation

First and foremost, you must have VLC and libvlc installed on your system and
the vlc binary must be in your PATH since we doesn't provide yet a cool
configuration system for this (contribution welcomed !)

Add this line to your application's Gemfile:

    gem 'activevlc'

And then execute:

    $ bundle

Or use the master branch on GitHub to test de development version by replacing
the line in your Gemfile by this one:

    gem 'activevlc', github: 'elthariel/activevlc'

Or install it yourself as:

    $ gem install activevlc

## Example

### Command line

Let's say you want to read an mp4 file, transcode it using different options, save the result to
another file while displaying it to control what's happening. Using the standard vlc's chain syntax
you'd have to write

    vlc input.mp4 :sout="#transcode{deinterlace, acodec=aac, ab=128, channels=2, vcodec=h264, venc=x264{bpyramid=strict, bframes=4, no-cabac}, vb=512}:duplicate{dst=standard{mux=mp4, dst='output.mp4'}, dst=display}"

Not very readable isn't it ? Let's try the same with ActiveVlc :

```ruby
AtiveVlc::pipe do
  transcode do
    deinterlace
    audio :aac do
      bitrate 128 # 128 kpbs
      channels 2
    end
    video :h264 do
      encoder :x264 do
        bpyramid :strict
        bframes 4
        cabac false
      end
      bitrate 512 # 512 kbps
    end
  end
  duplicate do
    to :file do
      mux :mp4
      dst 'output.mp4'
    end
    to :display
  end
end
```

This sintax might be a lot more verbose than the original vlc's one,
it is still A LOT more readable and understandable, and since this is plain ruby
you can add comment and arbitrary code !
Then you can run it using :

    activevlc exec /path/to/the/pipeline.rb input.mp4

### From Ruby code

You can also use ActiveVlc programmatically from your ruby code :

```ruby
def my_encoding_method(input, output)
  # Create the pipeline.
  pipe = ActiveVlc::pipe input do
    transcode do
      # Same syntax as above, also see spec/pipes
    end
    to :file, output
  end

  # Run it synchronously
  ActiveVlc::Runner.new(pipe).run
  # Your transcoding operation is over (except if there were strong errors)
end
```

## Development status

This gem is still under active development
althought it might already be usable for many usages.

If you have any trouble, idea or question, please use GitHub issue
system. If you have an idea with code attached to it, got to the
'Contributing' section below.

## Supported system/rubies

Ruby 1.8 is _NOT_ supported.

This gem is developped using MRI 2.0.0 on Debian 7 / Ubuntu 13.04 but it should work OOB on MRI 1.9 and other GNU/Linux systems.

Altough there might me some threading issues between the interpreter and libvlc, the specs are eported to pass against :
* Jruby (1.7)
* Rubinius (head) (with some minor problems)

I doesn't have access to any OSX boxes so but it should work as well, please let me know if you encounter any issue.

## Usage

Currently, the best documentation is to have a look to the spec (/spec/pipes)
or to run the CLI tool to get the embedded help.

## Known Issues

* We use a pretty ugly hack to be able to run pipelines synchronously
* You cannot (yet) configure output(s) from the command line, only with ruby
* There's currently almost no error reporting except from the one vlc's outputting on STDOUT. Vlc's logging and error reporting is pretty complex, i still need to take some time to figure it out.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Write some specs for your feature
4. Implements your feature and make your test pass
5. Commit your changes (`git commit -am 'Add some feature'`)
6. Push to the branch (`git push origin my-new-feature`)
7. Create new Pull Request
