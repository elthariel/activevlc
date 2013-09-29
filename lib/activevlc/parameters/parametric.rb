
# This concern handle Stage's named parameter storage and assignment logic
# using a visitor pattern
module ActiveVlc
  module Parametric
    extend ActiveSupport::Concern

    # Parameters represents named parameters used to configure and reuse
    # ActiveVlc's pipeline
    attr_reader :parameters

    def initialize
      @parameters = ParameterSet.new
    end

    # Apply named parameters to this Stage and to all the sub-Stages
    def visit(params = {})
      @parameters.visit params
    end

    def has_missing_parameter?
      @parameters.reduce(false) { |accu, duple| accu or not duple[1].set?}
    end
  end
end
