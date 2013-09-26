module ActiveVlc
  def self.pipe(inputs = nil, &block)
    ActiveVlc::Pipeline.new(inputs, &block)
  end
  def self.pipe_for(inputs = nil, &block)
    self.pipe(inputs, &block)
  end
  def self.parse(path)
    ActiveVlc::Pipeline.parse(path)
  end
end
