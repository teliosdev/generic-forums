class ApiController < ApplicationController
  before_filter :verify_api_request

  protected

  def verify_api_request
    error(404) unless api_request?
  end
end
