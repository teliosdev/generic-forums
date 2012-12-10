module GenericSupport::SoftDestroy
  module Model
    def self.included(base)
      base.send :extend, ClassMethods
    end

    module ClassMethods
      def can_be_soft_destroyed
        raise StandardError, "Requires Options!" unless option_proxy_name
        send :include, InstanceMethods
      end
    end

    module InstanceMethods
      def soft_destroy
        options_proxy[:deleted] = true
      end

      def undestroy
        options_proxy.delete :deleted
      end

      def soft_destroyed?
        options_proxy[:deleted] || false
      end

      def hard_destroy(*args, &block)
        destroy(*args, &block)
      end
    end
  end
end

ActiveSupport.on_load(:active_record) do
  include GenericSupport::SoftDestroy::Model
end
