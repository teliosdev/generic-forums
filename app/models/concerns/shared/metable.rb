module Shared
  module Metable
    extend ActiveSupport::Concern

    included do
      belongs_to :meta
      has_many :permissions, through: :meta
    end

    def is_metable?
      true
    end

    module ClassMethods

      def meta
        Meta.where(remote_type: name, collection: true).first
      end

      def is_metable?
        true
      end

    end
  end
end
