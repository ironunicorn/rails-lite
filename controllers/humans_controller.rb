require_relative '../models/human'

class HumansController < ControllerBase
  def new
    return redirect_to "/cats" if current_user
    @human = Human.new
    render "new"
  end

  def create
    return redirect_to "/cats" if current_user
    @human = Human.new(params["human"])
    @human.set({session_token: SecureRandom.urlsafe_base64})
    if @human.save
      flash["flash now"] = "Welcome #{@human.name}! Check below for an explanation."
      session[:session_token] = @human.session_token
      redirect_to("/cats")
    else
      flash.now["flash now"] = "Error!"
      render "new"
    end
  end
end
