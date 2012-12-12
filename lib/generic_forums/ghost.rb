module GenericForums::Ghost
  module Model
    def self.included(base)
      base.send :extend, ClassMethods
    end

    module ClassMethods
      def has_ghost
        send :include, InstanceMethods
      end

    end

    module InstanceMethods
      def ghost_permissions(user, action)
        Permission.where(
          :group_id    => user.group_ids,
          :action      => action,
          :remote_id   => get_ghost_ids(user),
          :remote_type => self.class.to_s
        )
      end

      def ghost?
        is_ghost
      end

      def get_ghost_ids(user)
        ids = []
        ghost = self.ghost(user)
        while ghost and not ids.include? ghost.id
          ids.push(ghost.id)
          ghost = ghost.ghost(user)
        end
        ids
      end
    end
  end
end

ActiveSupport.on_load(:active_record) do
  include GenericForums::Ghost::Model
end
