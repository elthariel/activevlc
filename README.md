# ActiveVlc

[![Gem Version](https://badge.fury.io/rb/activevlc.png)](http://badge.fury.io/rb/activevlc)
[![Code Climate](https://codeclimate.com/github/elthariel/activevlc.png)](https://codeclimate.com/github/elthariel/activevlc)
[![Build Status](https://travis-ci.org/elthariel/activevlc.png?branch=master)](https://travis-ci.org/elthariel/activevlc)
  [![Coverage Status](https://coveralls.io/repos/elthariel/activevlc/badge.png?branch=master)](https://coveralls.io/r/elthariel/activevlc?branch=master)

Do you know VLC, the famous media player ? I'm pretty sure you do !
Do you know this is also a pretty powerfull media processing and streaming framework ? Maybe...
Do you understand something about the command line syntax to access vlc's underlying
powers ? If you don't this tool is for you !

ActiveVlc provides a simple syntax to configure and run transcoding/streaming/processing
operations using VLC. Here's a simple example :

## Setup

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

    activevlc pipe exec /path/to/the/pipeline.rb input.mp4

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

## Named parameters

My fellow developpers, i now we all love reusable stuff, whether it's socks,
underwears or code. I'm pretty sure you'd also love to re-use the pipeline you
have or at least to make them a little bit configurable, may it be only for
the differents outputs. For this purpose, ActiveVlc provides a mecanism called
'named parameters'.

This features allows you to provide a placeholder instead of a value in the
pipeline file/code and to replace the placeholder with the actual value later,
just before running the pipeline, for example. Let's see how it works:

```ruby
ActiveVlc::pipe do
  transcode do
    audio :aac do
      bitrate param(:audio_bitrate) # parameter named 'audio_bitrate'
      channels p(:audio_channels)   # parameter named 'audio_channels'
     end
  end
  to :file do
    mux :mp4
    dst p(:outfile)                 # parameter named 'outfile'
  end
end
```

*Pay attention to the fact the named parameters are configured Pipeline-wise, there's no namespacing.*

In the example above, we define 3 named parameters that will be configured
later. There's no difference between the 'param' and 'p' methods: the latter
is just syntactic sugar. You have the choice between the 'explicit' and the
'lazy' way.

Now, we you want to run the pipeline you can provide the named paramters as a
Hash.

Using the command line :

    $> bundle exec activevlc pipe exec my_pipe input.mp3 --params=outfile:rspec.aac audio_bitrate:128 audio_channels:42
    [will produce you]
    :sout="#transcode{acodec=aac, ab=128, channels=42}:standard{mux=mp4, dst=rspec.aac}"

or directly from Ruby code :

```ruby
>> pipe # The pipeline defined above
=> ActiveVlc::Pipeline
>> pipe.params outfile: 'rspec.aac', audio_bitrate: 128, audio_channels: 42
=> nil
>> pipe.fragment
=> ":sout=\"#transcode{acodec=aac, ab=128, channels=42}:standard{mux=mp4, dst=rspec.aac}\""
```

## Integration

There's a pretty basic but still undocumentated carrierwave integration gem here : https://github.com/elthariel/carrierwave-activevlc
It doesn't work yet very well with carrierwave-backgrounder, but i think it can be fixed.

## Development status

This gem is still under development but it's already in use in one of my production box and is 
then already usable for many cool things.

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
