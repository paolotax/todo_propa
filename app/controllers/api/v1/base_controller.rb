class  Api::V1::BaseController < ActionController::Base

  # protect_from_forgery

  before_filter :set_header_without_cache

  def current_resource_owner
    User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  private

  	def set_header_without_cache
  		headers['Last-Modified'] = Time.now.httpdate
  	end

end