module PostEval
  class Schema
    attr_accessor :schema, :total_points

    def initialize(file=nil)
      @_schema_file = file
      @_points_bonus = 0
      @_sanitiation = []
      load_schema if file
    end

    def change_schema!(file)
      @_schema_file = file
      load_schema
    end

    def sanitize(raw)
      @_sanitization.each do |val|
        raise PostSchemaError, "Sanitization Error: Not an array (#{val.inspect})" unless val.is_a? Array
        regex = Regexp.new val[0]
        raw.gsub! regex, val[1]
      end
      raw
    end

    def load_schema
      fd = File.open @_schema_file
      @schema = YAML::load fd
    end

    def compile_schema!
      @_compiled_schema = []
      @total_points = _check_hash(@schema[:schema], 0, [])
      @_sanitization = @schema[:clean] || []
      raise PostSchemaError, "Sanitization value not an array #{@_sanitization.inspect}" unless @_sanitization.is_a? Array
    end

    def to_h
      {
        :total_points    => @total_points,
        :schema_file     => @_schema_file,
        :compiled_schema => @_compiled_schema,
        :bonus           => @_points_bonus,
        :clean           => @_sanitization
      }
    end

    def load_hash(hash)
      @total_points     = hash[:total_points]
      @_schema_file     = hash[:schema_file]
      @_compiled_schema = hash[:compiled_schema]
      @_points_bonus    = hash[:bonus]
      @_sanitization    = hash[:clean]
    end

    def save!
      File.open("#{@_schema_file}.ps_compile","w") do |f|
        YAML.dump to_h, f
      end
    end

    def self.load(hash)
      ps = self.new
      if hash.is_a? String
        ps.load_hash YAML::load File.open(hash)
      else
        ps.load_hash hash
      end
    end

    def self.load!(file)
      ps = self.new
      if File.exists? file + ".ps_compile"
        ps.load_hash YAML::load File.open(file+".ps_compile")
      else
        ps.change_schema! file
      end
      ps
    end

    def calculate(data)
      points = 0
      @_compiled_schema.each do |part|
        pointer = data
        stack = []
        part.each do |p|
          unless p.is_a? Numeric
            pointer = pointer[p]
            if pointer.nil?
              raise PostSchemaError, "There is no data field named #{p.to_s} (in [:#{stack.join(", :").chomp(", :")}]"
            end
            stack.push p
          else
            points+= pointer*p
          end
        end
      end
      points+= @_points_bonus if @_points_bonus
      [points, points/@total_points]
    end

    protected

    def _check_hash(hash, points, stack)
      hash.each do |key,val|
        if val.is_a? Hash
          points = _check_hash val, points, stack.clone.push(key)
        elsif val.is_a? Numeric and key != :extra and key != :bonus
          points+= val
          @_compiled_schema.push(stack.clone.push(key).push(val))
        elsif key == :extra
          points+= val
        elsif key == :bonus
          @_points_bonus+= val
        else
          raise PostSchemaError, "Unknown Field Type: #{val.class} (for value #{key.to_s})"
        end
      end
      points
    end

  end

  class SchemaError < StandardError
  end
end
