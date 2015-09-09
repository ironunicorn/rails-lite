class Route
  attr_reader :pattern, :http_method, :controller_class, :action_name

  def initialize(pattern, http_method, controller_class, action_name)
    @pattern = pattern
    @http_method = http_method
    @controller_class = controller_class
    @action_name = action_name
  end

  def matches?(req)
    params = Params.new(req)
    if params["_method"]
      params["_method"].downcase.to_sym == http_method &&
        req.path =~ pattern
    else
      req.request_method.downcase.to_sym == http_method &&
        req.path =~ pattern
    end
  end

  def run(req, res)
    route_params = {}
    match_values = req.path.match(pattern)
    if match_values
      match_values.names.each do |key|
        route_params[key] = match_values[key]
      end
    end
    control = controller_class.new(req, res, route_params)
    control.invoke_action(action_name)
  end
end

class Router
  attr_reader :routes

  def initialize
    @routes = []
  end

  def add_route(pattern, method, controller_class, action_name)
    @routes << Route.new(pattern, method, controller_class, action_name)
  end

  def draw(&proc)
    self.instance_eval(&proc)
  end

  [:get, :post, :put, :delete].each do |http_method|
    define_method(http_method) do |pattern, controller_class, action_name|
      add_route(pattern, http_method, controller_class, action_name)
    end
  end

  def match(req)
    @routes.find { |route| route.matches?(req) }
  end

  def run(req, res)
    route = match(req)
    return res.status = 404 unless route
    route.run(req, res)
  end
end
