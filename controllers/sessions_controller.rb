require_relative '../models/human'
require 'securerandom'

class SessionsController < ControllerBase
  def new
    return redirect_to "/cats" if current_user
    @human = Human.new
    render "new"
  end

  def create
    return redirect_to "/cats" if current_user
    @human = Human.where(params["human"]).first
    if @human
      flash["flash now"] = "Welcome #{@human.name}! Check below for an explanation."
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
    current_user = nil
    session["session_token"] = nil
    redirect_to("/cats")
  end
end
