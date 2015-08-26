require_relative '../models/cat'
require 'byebug'

class CatsController < ControllerBase
  def index
    @cats = Cat.all
    render "index"
  end

  def new
    render "new"
  end

  def create
    @cat = Cat.new(params["cat"])
    if @cat.save
      flash["flash now"] = "#{@cat.name} created!"
      redirect_to("/cats")
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
    render "edit"
  end

  def update
    @cat = Cat.find(params[:id])
    @cat.set(params["cat"])
    if @cat.save
      redirect_to("/cats/#{@cat.id}")
    else
      render "error"
    end
  end



  def destroy
    cat = Cat.find(params[:id])
    cat.destroy
    flash["flash now"] = "#{cat.name} woke up!"
    redirect_to("/cats")
  end
end
