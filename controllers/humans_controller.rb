require_relative '../models/human'

class HumansController < ControllerBase
  def new
    @human = Human.new
    render "new"
  end

  def create
    @human = Human.new(params["human"])
    if @human.save
      flash["flash now"] = "Welcome #{@human.name}!"
      @human.set({session_token: SecureRandom.urlsafe_base64})
      @human.save
      session[:session_token] = @human.session_token
      redirect_to("/cats")
    else
      flash.now["flash now"] = "Error!"
      render "new"
    end
  end
end
