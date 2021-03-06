##
## stage.rb
## Login : <lta@still>
## Started on  Wed Jul  3 16:08:37 2013 Lta Akr
## $Id$
##
## Author(s):
##  - Lta Akr <>
##
## Copyright (C) 2013 Lta Akr

module ActiveVlc
  module Stage
  end
end

# Common features shared by most Stages
require 'activevlc/stage/base'

# All implemented stages
require 'activevlc/stage/input'
require 'activevlc/stage/stream'
require 'activevlc/stage/duplicate'
require 'activevlc/stage/transcode'
require 'activevlc/stage/gather'
require 'activevlc/stage/chain'
