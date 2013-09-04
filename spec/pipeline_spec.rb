##
## pipeline_spec.rb
## Login : <lta@still>
## Started on  Wed Jul  3 15:57:47 2013 Lta Akr
## $Id$
##
## Author(s):
##  - Lta Akr <>
##
## Copyright (C) 2013 Lta Akr
## This program is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 3 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program; if not, write to the Free Software
## Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
##

require 'spec_helper'

describe ActiveVlc::Pipeline do
  describe '\'basic\' pipeline' do
    it 'returns nil if the file doesn\'t exists' do
      ActiveVlc::Pipeline.parse('dontexist.rb').should be_nil
    end

    it 'is loaded' do
      pipe = ActiveVlc::Pipeline.parse 'spec/pipes/basic.rb'
      pipe.class.should be(ActiveVlc::Pipeline)
    end

    it 'can produces a fragment' do
      pipe = ActiveVlc::Pipeline.parse 'spec/pipes/basic.rb'
      pipe.fragment.should match(/input.mp4/)
    end
  end
end
