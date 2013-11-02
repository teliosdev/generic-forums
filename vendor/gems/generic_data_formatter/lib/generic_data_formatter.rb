require "generic_data_formatter/version"

module GenericDataFormatter

  @_formatters = {}

  def self.add_formatter(name, klass = nil, &block)
    @_formatters[name.to_s] = klass || block
  end

  def self.format(format, body, options = {})
    f = @_formatters[format.to_s]
    case f
    when Module
      f.format(body, options)
    when Proc
      f.call(body, options)
    when nil
      body
    else
      raise ArgumentError,
        "Unkown formatter for #{format}: #{f.class}"
    end
  end

  def self.reset!
    @_formatters = {}
  end

  def self.formatter(format)
    @_formatters[format.to_s]
  end

  def self.formats
    @_formatters.keys.map(&:to_sym)
  end
end
