require_relative '../models/cat'

class CatsController < ControllerBase
  def index
    @cats = Cat.all
    render "index"
  end

  def new
    return redirect_to "/cats" unless current_user
    render "new"
  end

  def create
    return redirect_to "/cats" unless current_user
    @cat = Cat.new(params["cat"])
    @cat.set(human_id: current_user.id)
    if @cat.save
      flash["flash now"] = "#{@cat.name} created! Check below for an explanation."
      redirect_to "/cats/#{@cat.id}"
    else
      flash.now["flash now"] = "Error!"
      render "new"
    end
  end

  def show
    @cat = Cat.find(params[:id])
    render "show"
  end

  def edit
    @cat = Cat.find(params[:id])
    return redirect_to "/cats" unless current_user && current_user.id == @cat.human_id
    render "edit"
  end

  def update
    @cat = Cat.find(params[:id])
    return redirect_to "/cats" unless current_user && current_user.id == @cat.human_id
    @cat.set(name: params["cat"]["name"])
    if @cat.save
      flash["flash now"] = "#{@cat.name} updated! Check below for an explanation."
      redirect_to("/cats/#{@cat.id}")
    else
      render "error"
    end
  end

  def destroy
    cat = Cat.find(params[:id])
    return redirect_to "/cats" unless current_user && current_user.id == cat.human_id
    cat.destroy
    flash["flash now"] = "#{cat.name} woke up! Check below for an explanation."
    redirect_to("/cats")
  end
end
