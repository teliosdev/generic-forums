class UsersController < ApplicationController

	def new
		@user = User.new
	end

	def create
		@user = User.new
		@user.name     = params[:user][:name    ]
		@user.email    = params[:user][:email   ]
		@user.password = params[:user][:password]
		@user.password_confirmation = params[:user][:password_confirmation]
		groups = []
		AppConfig.default_user_groups.each do |gr|
			groups << Group.find_by_name(gr)
		end
		@user.groups   = groups
		unless @user.valid?
			render "new" and return
		else
			@user.save!
			redirect_to root_path
		end
	end

end
