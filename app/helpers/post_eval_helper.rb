module PostEvalHelper
  class Eval

    attr_accessor :raw, :ps
    attr_reader :data, :points

    def initialize(ps=DEFAULT_SCHEMA)
      @data = {}
      @ps   = ps
      @points= 0
    end

    def score(raw)
      @raw = ps.sanitize raw.dup
      @data = generate
      @points = ps.calculate @data
      @points = 0 if @points[0].nan? or @points[1].nan?
    end

    def generate
      @data = { :letters => {}, :words => {}, :sentences => {} }
      generate_letter_data
      generate_word_data
      generate_sentence_data
      @data
    end

    def generate_letter_data
      @data[:letters][:total]     = @raw.length
      @data[:letters][:upper]     = @raw.count "A-Z"
      @data[:letters][:lower]     = @raw.count "a-z"
      @data[:letters][:white]     = @raw.count "\s"
      @data[:letters][:numbers]   = @raw.count "0-9+=/-_"
      @data[:letters][:clean]     = @data[:letters][:lower] + @data[:letters][:upper] + @data[:letters][:numbers]
      @data[:letters][:other]     = @data[:letters][:total] - (@data[:letters][:clean] + @data[:letters][:white])
      _generate_letter_ratios
    end

    def generate_word_data
      words = raw.scan(/\w+/).map { |x| x.length }
      words.reject! do |length|
        # if it's less than two it doesnt count
        length <= 2 or length > 13
        # if it's greater than thirteen then it's probably someone trying
        # to exploit the point system.  The actual std deviation of
        # a sample set of english words is 2, with an average of 5.
      end
      words.push 0 if words.length < 1
      @data[:words][:number]        = words.length
      @data[:words][:range_set]     = [words.min || 0, words.max || 0]
      @data[:words][:range]         = @data[:words][:range_set][1] - @data[:words][:range_set][0]
      @data[:words][:average]       = (words.inject(:+).fdiv words.size) || 0
      _generate_word_ratios
    end

    def generate_sentence_data
      @data[:sentences][:first_letter]          = raw[0,1].count("A-Z")
      @data[:sentences][:list]                  = @raw.scan(/[A-Za-z][\w\ \,\-\(\)]+?(?:\.|\?|\!)+?\s*/)
      @data[:sentences][:count]                 = @data[:sentences][:list].length
      @data[:sentences][:info]                  = {}
      _generate_sentence_info
      _generate_sentence_ratios
    end

    def inspect
      "#<PostEvalHelper::Schema #{@points}>"
    end

    protected

    def _generate_letter_ratios
      data_types = []
      @data[:letters].each_key do |key|
        data_types.push key
      end
      @data[:letters][:ratios] = {}

      data_types.permutation(2) do |permute|
        v1 = @data[:letters][permute[0]]
        v2 = @data[:letters][permute[1]]
        v3 = v1.fdiv v2
        unless v3.finite?
          v3 = 0.0
        end
        @data[:letters][:ratios]["#{permute[0]}_to_#{permute[1]}".to_sym] = v3
      end
    end

    def _generate_word_ratios
      @data[:words][:ratios] = {}
      @data[:words][:ratios][:clean_to_average] = @data[:letters][:clean].fdiv @data[:words][:average]
      @data[:words][:ratios][:number_to_possible] = @data[:words][:number].fdiv @data[:words][:ratios][:clean_to_average]
      @data[:words][:ratios].map do |name,x|
        unless x.finite?
          0.0
        else
          x
        end
      end
    end

    def _generate_sentence_info
      @data[:sentences][:info] = {}
      caps   = 0
      puncts = 0
      spaces = 0
      propers= 0
      @data[:sentences][:list].each do |sentence|
        s_cap    = sentence[0,1].count("A-Z")
        s_punct  = sentence.count(".!?")
        s_space  = sentence.scan(/\s*\Z/)[0].length
        if s_cap == 1 and s_punct == 1 and (1..2).include? s_space
          propers+= 1
        end
        caps  += s_cap
        puncts+= s_punct
        spaces+= s_space
      end
      @data[:sentences][:info][:capitalization] = caps
      @data[:sentences][:info][:punctuation]    = puncts
      @data[:sentences][:info][:spaces]         = spaces
      @data[:sentences][:info][:proper]         = propers
    end

    def _generate_sentence_ratios
      @data[:sentences][:ratios] = {}
      @data[:sentences][:ratios][:proper_to_count] = @data[:sentences][:info][:proper].fdiv(@data[:sentences][:count])
      unless @data[:sentences][:ratios][:proper_to_count].finite?
        @data[:sentences][:ratios][:proper_to_count] = 0.0
      end
      ary = [@data[:sentences][:ratios][:proper_to_count], @data[:sentences][:first_letter]]
      @data[:sentences][:ratios][:ptc_fl_avg]      =
        ary.inject(:+).fdiv ary.size
    end

  end

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

  DEFAULT_SCHEMA = Schema.new
  DEFAULT_SCHEMA.schema = GenericForums::Application.config.schema
  DEFAULT_SCHEMA.compile_schema!
end
