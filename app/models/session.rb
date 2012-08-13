class Session < Authlogic::Session::Base
  authenticate_with User
  consecutive_failed_logins_limit AppConfig.max_login_tries
  failed_login_ban_for            AppConfig.exceed_login_timeout
end
