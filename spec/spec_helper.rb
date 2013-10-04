##
## spec_helper.rb
## Login : <lta@still>
## Started on  Wed Jun 12 14:07:00 2013 Lta Akr
## $Id$
##
## Author(s):
##  - Lta Akr <>
##
## Copyright (C) 2013 Lta Akr

unless ENV['NO_COVERAGE']
  require 'simplecov'
  require 'coveralls'

  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::HTMLFormatter,
    Coveralls::SimpleCov::Formatter
  ]
  SimpleCov.start do
    add_filter '/spec/'

    add_group "Stages", '/stage/'
    add_group "DSL", '/dsl/'
    add_group "LibVlc", '/libvlc/'
  end
end

require 'activevlc'

RSpec.configure do |config|
  config.order_groups do |groups|
    groups.shuffle!
    runner = groups.index { |g| g.described_class == ActiveVlc::Runner }
    if runner
      runner = groups.delete_at runner
      groups.unshift runner
    end
    groups
  end
  #
  # We force the run order of the specs to ensure runner_specs get executed first.
  # This is important because libvlc seems to creates some internal state that
  # leads to a deadlock when executed last
  #
  # files = config.instance_variable_get(:@files_to_run)
  # puts files
  # files.delete ''

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  #config.order = "random"
end

