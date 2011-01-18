class ApplicationController < ActionController::Base
  protect_from_forgery
  #before_filter :require_http_auth_user

  private

  def require_http_auth_user
    authenticate_or_request_with_http_basic do |username, password|
      if username == 'asd' and password == 'cure'
        true
      else
        false
      end
    end
  end
end
