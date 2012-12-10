module GenericSupport::Options
  module Model
    def self.included(base)
      base.send :extend, ClassMethods
    end

    module ClassMethods
      def has_option(name)
        @_option_proxy_name = name
        define_method name do
          @_options_proxy ||= Proxy.new(self, name)
        end
        include InstanceMethods
        serialize name, Hash
      end

      def option_proxy_name
        @_option_proxy_name
      end

    end

    module InstanceMethods
      def options_proxy
        if self.class.option_proxy_name
          self.send self.class.option_proxy_name
        end
      end
    end

    class Proxy
      extend Forwardable

      def initialize(record, options_method)
        @record = record
        @options_method = options_method
        @_options = @record.read_attribute(@options_method) || {}
      end

      def []=(key, value)
        @_options[key] = value
        refresh_options
      end

      def delete(key, &block)
        v = @_options.delete key, &block
        refresh_options
        v
      end

      def transaction(&block)
        @record.transaction do
          block.call self
        end
      end

      def to_h
        @_options
      end

      def_delegators :@_options, :each, :[], :size
      protected

      def refresh_options
        @record.update_attribute(@options_method, @_options)
      end
    end
  end
end

ActiveSupport.on_load(:active_record) do
  include GenericSupport::Options::Model
end
