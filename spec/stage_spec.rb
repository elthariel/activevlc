##
## stage_spec.rb
## Login : <lta@still>
## Started on  Thu Sep  5 09:24:03 2013 Lta Akr
## $Id$
##
## Author(s):
##  - Lta Akr <>
##
## Copyright (C) 2013 Lta Akr

require 'spec_helper'

describe ActiveVlc::Stage::Base do
  it 'has a type' do
    ActiveVlc::Stage::Base.new(:standard).type.should eq(:standard)
  end

  it 'has an options hash-like' do
    stage = ActiveVlc::Stage::Base.new
    stage.options.respond_to?(:each).should be_true
    stage.options.respond_to?(:[]).should be_true
    stage.options.respond_to?(:[]=).should be_true
  end

  it 'behaves like a hash' do
    stage = ActiveVlc::Stage::Base.new
    stage[:test] = 42
    stage[:test].should eq(42)
    stage.options[:test].should eq(42)
  end

  it 'renders options in fragment -- no suboption' do
    stage = ActiveVlc::Stage::Base.new
    stage[:test] = 42
    stage.fragment.should eq('dummy{test=42}')
  end

  it 'renders options in fragment' do
    stage = ActiveVlc::Stage::Base.new
    stage[:test] = 42
    stage[:opt1] = 'pwet'
    stage[:sub] = {_this_: 'this', opt2: 'foo'}
    stage[:sub2] = {opt3: 'bar'}

    stage.fragment.should eq("dummy{test=42, opt1='pwet', sub=this{opt2='foo'}, sub2{opt3='bar'}}")
  end
end
