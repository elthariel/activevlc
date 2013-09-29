module ActiveVlc
  class ParameterSet < Hash

    # Equivalent for set[param.name] = param
    def <<(param)
      self[param.name.to_sym] = param
      self
    end

    def [](name)
      super name.to_sym
    end
    def []=(name, value)
      super name.to_sym, value
    end

    # Does this parameter set has a param called 'name' ?
    def has_param?(name)
      self.has_key? name.to_sym
    end

    # Get the value for the parameter named 'name'
    def value_for(name)
      self[name.to_sym].value
    end

    # Set the value for the parameter named 'name'
    def set_value_for(name, value)
      self[name.to_sym].value = value
    end

    # @internal
    # Merge a hash of 'name: value' into the parameter set
    def visit(params)
      params.each do |name, value|
        set_value_for name, value if has_param? name
      end
    end

  end
end
