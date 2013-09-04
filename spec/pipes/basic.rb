##
## basic.rb
## Login : <lta@still>
## Started on  Wed Jun 12 14:41:04 2013 Lta Akr
## $Id$
##
## Author(s):
##  - Lta Akr <>
##
## Copyright (C) 2013 Lta Akr

# Basic pipe for rspec testing

require 'activevlc'

ActiveVlc::Pipeline.for 'input.mp4' do
  to :display
end
