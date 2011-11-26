class ApplicationController < ActionController::Base
  protect_from_forgery
  
  helper :layout
  
  before_filter :authenticate_user!
  
end
