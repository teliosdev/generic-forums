module FrenchVanilla

  module PostExtensions

    def self.included(base)
      base.send :include, InstanceMethods
      base.send :after_save,  :calculate_points
      base.send :before_destroy, :remove_points
      base.send :handle_asynchronously, :calculate_points
      base.send :handle_asynchronously, :remove_points
    end

    module InstanceMethods

      def calculate_points
        puts "CALC_POINTS" + ("_"*20)
        points = (PostEval::Eval.new.score(body) || [0,0])[1].round(2)
        prev_points = read_attribute(:points)
        points -= prev_points # so if you edit a post you don't get extra points
        puts "POINTS: #{points}"
        puts "PREV_POINTS: #{prev_points}"
        #update_attribute(:points, points)
        update_column :points, points
        user.update_attribute(:points,
          user.points +=
          points
        )
        true
      end

      def remove_points
        user.update_attribute(:points, user.points -= read_attribute(:points))
        nil
      end
    end
  end
end
