class ApplicationController < ActionController::Base
  protect_from_forgery
  helper :application
  include ApplicationHelper
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
    @session = Session.find
    @user    = @session.record if @session
    @user    = User.find(0) unless @user
  end

  def require_login
    raise StandardError unless responds_to?(:permission)
  end
end
