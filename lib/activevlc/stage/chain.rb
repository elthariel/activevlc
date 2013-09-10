##
## chain.rb
## Login : <lta@still>
## Started on  Tue Sep 10 19:43:11 2013 Lta Akr
## $Id$
##
## Author(s):
##  - Lta Akr <>
##
## Copyright (C) 2013 Lta Akr

module ActiveVlc::Stage
  class Chain < Stream
    def fragment
      @chain.map{|s| s.fragment}.join ':'
    end
  end
end
