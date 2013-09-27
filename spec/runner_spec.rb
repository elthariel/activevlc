
require 'spec_helper'

describe ActiveVlc::Runner do
  it 'can be created' do
    pipe = ActiveVlc.parse('spec/pipes/no_input.rb')
    runner = ActiveVlc::Runner.new(pipe, "--play-and-exit")
    runner.should be_a_kind_of(ActiveVlc::Runner)
  end

  it 'can be ran' do
    out = "output.ogg"
    pipe = ActiveVlc.parse('spec/pipes/no_input.rb')
    runner = ActiveVlc::Runner.new(pipe)
    pipe.input << 'spec/samples/click.wav'

    `rm -f #{out}`
    runner.run
    File.exist?(out).should be_true
    `rm -f #{out}`
  end

  it 'can be ran in a separate process' do
    out = "output.ogg"
    pipe = ActiveVlc.parse('spec/pipes/no_input.rb')
    runner = ActiveVlc::Runner.new(pipe)
    pipe.input << 'spec/samples/click.wav'

    `rm -f #{out}`
    runner.run
    File.exist?(out).should be_true
    `rm -f #{out}`
  end
end
