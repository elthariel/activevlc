##
## basic_pipe_spec.rb
## Login : <lta@still>
## Started on  Wed Jun 12 20:46:26 2013 Lta Akr
## $Id$
##
## Author(s):
##  - Lta Akr <>
##
## Copyright (C) 2013 Lta Akr

require 'spec_helper'

describe ActiveVlc do
  describe '::pipe_for' do
    it 'creates a new Pipeline' do
      ActiveVlc.pipe_for('test.mp4'){}.should be_a(ActiveVlc::Pipeline)
    end

    it 'has input file in the fragment string' do
      ActiveVlc.pipe_for('test.mp4'){}.fragment.should match('test.mp4')
    end

    it 'handles an array of input' do
      ActiveVlc.pipe_for(['test.mp4', 'test.flv']){}.fragment.should match(/test\.mp4.+test\.flv/)
    end

  end
end

