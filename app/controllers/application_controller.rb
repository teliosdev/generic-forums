class ApplicationController < ActionController::Base

  include ApplicationHelper

  protect_from_forgery
  helper :application
  before_filter :forum_info, :check_content
  helper_method :current_user

  protected

  def forum_info
    @forum = OpenStruct.new
    @forum.name    = AppConfig.forum_name
    @forum.version = AppConfig.forum_version

    @breadcrumbs = BreadcrumbHelper::BreadcrumbSet.new
    @breadcrumbs.add :name => "Home", :link => "/"
  end

  def error(number)
    response.status = number
    render "error/#{number}"
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

  def check_content
    return unless params[:format]
    c = Mime::Type.lookup_by_extension params[:format]
    request.headers["Content-Type"] = c.to_s
  end

  def require_login
    #raise StandardError unless responds_to?(:permission)
  end
end
