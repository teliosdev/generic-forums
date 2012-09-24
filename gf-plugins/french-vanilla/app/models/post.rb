module FrenchVanilla

  module PostExtensions

    def self.included(base)
      base.send(:include, InstanceMethods)
      base.send(:before_save, :calculate_points)
      base.send(:before_destroy, :remove_points)
    end

    module InstanceMethods

      protected

      def calculate_points
        puts "CALC_POINTS" + ("_"*20)
        points = (PostEval::Eval.new.score(body) || [0,0])[1].round(2)
        prev_points = read_attribute(:points)
        points - prev_points # so if you edit a post you don't get extra points
        puts "POINTS: #{points}"
        write_attribute(:points, points)
        user.update_attribute(:points,
          user.points +=
          points
        )
        nil
      end

      def remove_points
        user.update_attribute(:points, user.points -= read_attribute(:points))
        nil
      end
    end
  end
end
