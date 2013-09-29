module ActiveVlc
  # Represent a parameter for a certain option in a Pipeline
  class Parameter
    attr_accessor :value
    attr_reader :name

    #
    # Creates a named parameter. 'name' if the parameter's name and 'value'
    # is its default value
    #
    def initialize(name, value = nil)
      @name = name
      @value = value
    end

    def set?
      not value.nil?
    end

    def to_s
      if @value
        @value.to_s
      else
        "value for #{name} not set"
      end
    end
  end
end
