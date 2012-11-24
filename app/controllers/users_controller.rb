class UsersController < ApplicationController

	def new
		@new_user = User.new
	end

	def create
		@new_user = User.new
		@new_user.name     = params[:user][:name    ]
		@new_user.email    = params[:user][:email   ]
		@new_user.password = params[:user][:password]
		@new_user.password_confirmation = params[:user][:password_confirmation]
		groups = []
		opts = {}

		AppConfig.user_options.each do |k, v|
			opts[k.intern] = AppConfig.user_options[k][:default]
		end

		@new_user.options = opts

		AppConfig.default_user_groups.each do |gr|
			groups << Group.find_by_name(gr)
		end
		@new_user.groups   = groups
		unless @new_user.valid?
			render "new" and return
		else
			@new_user.save!
			redirect_to root_path
		end
	end

end
