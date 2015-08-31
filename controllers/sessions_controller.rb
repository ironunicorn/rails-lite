require_relative '../models/human'
require 'securerandom'

class SessionsController < ControllerBase
  def new
    @human = Human.new
    render "new"
  end

  def create
    @human = Human.where(params["human"]).first
    if @human
      flash["flash now"] = "Welcome #{@human.name}!"
      @human.set({session_token: SecureRandom.urlsafe_base64})
      @human.save
      session[:session_token] = @human.session_token
      redirect_to("/cats")
    else
      flash.now["flash now"] = "Account could not be found."
      render "new"
    end
  end

  def destroy
    current_user.set({session_token: SecureRandom.urlsafe_base64})
    current_user.save
    current_user = null
    session[:session_token] = null
  end
end
