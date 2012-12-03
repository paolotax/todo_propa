class Api::V1::TokensController  < ApplicationController
  
  skip_before_filter :verify_authenticity_token
  
  respond_to :json
  
  def create
    username = params[:username]
    password = params[:password]
    if request.format != :json
      render :status=>406, :json=>{:message=>"The request must be json"}
      return
    end

    if username.nil? or password.nil?
      render :status=>400,
            :json=>{:message=>"The request must contain the user username and password."}
      return
    end

    @user=User.find_by_username(username.downcase)

    if @user.nil?
      logger.info("User #{username} failed signin, user cannot be found.")
      render :status=>401, :json=>{:message=>"Invalid username or passoword."}
      return
    end

    # http://rdoc.info/github/plataformatec/devise/master/Devise/Models/TokenAuthenticatable
    @user.ensure_authentication_token!

    if not @user.valid_password?(password)
      logger.info("User #{username} failed signin, password \"#{password}\" is invalid")
      render :status=>401, :json=>{:message=>"Invalid username or password."}
    else
      render :status=>200, :json=>{:auth_token=>@user.authentication_token}
    end
  end

  def destroy
    @user=User.find_by_authentication_token(params[:id])
    if @user.nil?
      logger.info("Token not found.")
      render :status=>404, :json=> { :message => "Invalid token." }
    else
      @user.reset_authentication_token!
      render :status=>200, :json=>{:auth_token=>params[:id]}
    end
  end

end