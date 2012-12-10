class GenericSupport::AppConfigAccessor
  def initialize(opts = {})
    @opts = opts
  end

  #def [](key)
  #  @opts[key.to_s]
  #end

  #def method_missing(sym)
  #  if self[sym].is_a? Hash
  #    AppConfigAccessor.new self[sym]
  #  else
  #    self[sym]
  #  end
  #end

  def opts(sym)
    @opts[sym.to_s]
  end

  def [](sym)
    if opts(sym).is_a? Hash
      AppConfigAccessor.new opts(sym)
    else
      opts(sym)
    end
  end

  def method_missing(sym)
    self[sym]
  end

  def as_hash
    Hash[@opts.map { |k,v| [k.intern, v] }]
  end
end

filename = File.expand_path("config/app_config.yml", Rails.root)
if File.exist? filename
  GenericSupport::AppConfig = AppConfig = GenericSupport::AppConfigAccessor.new YAML.load_file(filename)[Rails.env]
else
  raise "Couldn't load application configuration from config/app_config.yml"
end

def p?(*args)
  AppConfig.plugin?(*args)
end
