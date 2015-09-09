class RootController < ControllerBase
  def root
    render 'root'
  end

  def go_live
    render 'go_live'
  end
end
