class ApplicationController < ActionController::Base
  protect_from_forgery
  helper :application
  before_filter :forum_info, :user_check

  protected

  def forum_info
    @forum = OpenStruct.new
    @forum.name    = GenericForums::Application.config.forum_name
    @forum.version = GenericForums::Application.config.forum_version

    @page = OpenStruct.new
    @page.title = @forum.name + " / " + controller_name + " / " + action_name

    @breadcrumbs = ApplicationHelper::BreadcrumbSet.new
    @breadcrumbs.add :name => "Home", :link => "/"
  end

  def user_check
    if session[:user_id]
      @user = User.find_by_id session[:user_id]
    else
      @user = User.find 0
    end
  end

  def require_login

  end
end
