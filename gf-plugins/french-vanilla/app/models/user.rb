module FrenchVanilla
	module UserExtensions

		def self.included(base)
			base.send :include, InstanceMethods
			base.send :handle_asynchronously, :check_points
		end

		module InstanceMethods

			def check_points
				update_column :points, 0.0
				posts.each do |p|
					p.calculate_points
				end
			end

		end

	end
end
