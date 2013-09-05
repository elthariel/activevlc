##
## duplicate.rb
## Login : <lta@still>
## Started on  Wed Sep  4 17:29:45 2013 Lta Akr
## $Id$
##
## Author(s):
##  - Lta Akr <>
##
## Copyright (C) 2013 Lta Akr

# input.mp3 :sout="#duplicate{dst=display, dst=std{dst='output.mp3'}}"
ActiveVlc::Pipeline.for 'input.mp3' do
  duplicate do
    to :display
    to file: 'output.mp3'
  end
end
