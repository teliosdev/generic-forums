class SessionsController < ApplicationController
  def new
    if session[:login_ban_time] and session[:login_ban_time] > Time.now
      render "max_tries" and return
    end
  end

  def create
    unless (user = User.authenticate params[:name], params[:password])
      flash.now[:error] = "Username/Email and Password Combination not Found (#{session[:login_tries] || 0} tries)"
      if session[:login_tries]
        if session[:login_tries] > GenericForums::Application.config.max_login_tries
          session[:login_ban_time] = Time.now + 30.minutes
          render "max_tries" and return
        end
        session[:login_tries] = session[:login_tries] +1
      else
        session[:login_tries] = 1
      end
      render "new" and return
    else
      session[:login_tries] = 0
      session[:user_id] = user.id
      redirect_to "/"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to "/"
  end
end
