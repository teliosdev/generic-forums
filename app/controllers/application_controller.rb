class ApplicationController < ActionController::Base

  include ApplicationHelper

  protect_from_forgery
  helper :application
  before_filter :forum_info, :check_content, :set_locale
  helper_method :current_user
  rescue_from ActiveRecord::RecordNotFound, :with => :rescue_exception

  protected

  def forum_info
    @forum = OpenStruct.new
    @forum.name    = AppConfig.forum_name
    @forum.version = AppConfig.forum_version

    @breadcrumbs = BreadcrumbHelper::BreadcrumbSet.new
    @breadcrumbs.add :name => t('home.home'), :link => "/"
  end

  def error(number=404)
    response.status = number
    render "error/#{number}"
    true
  end

  def rescue_exception(exception)
    if exception.is_a? ActiveRecord::RecordNotFound
      error
    else
      error(400)
    end
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

  def api_request?
    params[:format] and params[:format] != "html"
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options(options={})
    if I18n.locale != I18n.default_locale
      { :locale => I18n.locale }
    else
      {}
    end
  end
end
