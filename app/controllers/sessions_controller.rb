class SessionsController < ApplicationController
  def new
    if session[:login_ban_time] and session[:login_ban_time] > Time.now
      render "max_tries" and return
    end
    @session = Session.new
  end

  def create
    @session = Session.new(params[:session])
    if @session.save
      redirect_to "/"
    else
      render :action => :new
    end
  end

  def destroy
    @session.destroy
    redirect_to "/"
  end
end
