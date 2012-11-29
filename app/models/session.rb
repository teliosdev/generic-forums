class Session < Authlogic::Session::Base
  authenticate_with User
  consecutive_failed_logins_limit AppConfig.max_login_tries
  failed_login_ban_for            AppConfig.exceed_login_timeout
  params_key                      "session"
  single_access_allowed_request_types ["application/json", "application/xml"]
  generalize_credentials_error_messages true
end
