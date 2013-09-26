##
## no_input.rb
## Login : <lta@still>
## Started on  Wed Jun 12 14:45:36 2013 Lta Akr
## $Id$
##
## Author(s):
##  - Lta Akr <>
##
## Copyright (C) 2013 Lta Akr

ActiveVlc::pipe do
  transcode do
    audio :vorbis
  end
  to(:file) do
    mux :ogg
    dst 'output.ogg'
  end
end
