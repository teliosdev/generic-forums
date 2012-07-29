class ApplicationController < ActionController::Base
  protect_from_forgery
  helper :application
  before_filter :forum_info

  protected

  def forum_info
    @forum = OpenStruct.new
    @forum.name    = GenericForums::Application.config.forum_name
    @forum.version = GenericForums::Application.config.forum_version

    @breadcrumbs = ApplicationHelper::BreadcrumbSet.new
    @breadcrumbs.add :name => "Home", :link => "/"

    current_user
  end

  def current_session
    @session ||= Session.find
  end

  def current_user
    @user ||= if current_session and current_session.record
      current_session.record
    else
      User.guest
    end
  end

  def require_login
    raise StandardError unless responds_to?(:permission)
  end
end
