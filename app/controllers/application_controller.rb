class ApplicationController < ActionController::Base
  protect_from_forgery
  
  
  helper :layout

  # respond_to_mobile_requests :skip_xhr_requests => false
  # before_filter :prepare_for_mobile
  
  before_filter :authenticate_user!
  
  private
    
    def prepare_for_mobile    
      request.format = :mobile if mobile_user_agent?
    end

    def mobile_user_agent?
        request.env["HTTP_USER_AGENT"]
        request.env["HTTP_USER_AGENT"][/Mobile|webOS|Android/]
        # request.user_agent =~ /Mobile|webOS|Android/
    end

end
