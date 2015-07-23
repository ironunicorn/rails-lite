require 'active_support'
require 'active_support/core_ext'
require 'erb'
require 'active_support/inflector'
require_relative './session'
require_relative './params'
require_relative './auth_token'

class ControllerBase
  attr_reader :req, :res, :params

  # Setup the controller
  def initialize(req, res, route_params = {})
    @req = req 
    @res = res
    @params = Params.new(req, route_params)
  end


  # Helper method to alias @already_built_response
  def already_built_response?
    @already_built_response
  end


  def flash
    @flash ||= Flash.new(req)
  end

  def auth_token
    @auth_token = AuthToken.new(flash)
  end

  def form_authenticity_token
    auth_token.security
  end

  def protect_from_forgery
    raise "Error!" unless params[:security] && flash["security"] == params[:security] 
  end

  def invoke_action(name)
    protect_from_forgery if name == :post
    self.send(name)
  end

  # Set the response status code and header
  def redirect_to(url)
    raise if already_built_response?
    res.status = 302
    res["Location"] = url
    @already_built_response = true
    session.store_session(res)
    flash.store_flash(res)
  end

  def render(template_name)
    f = File.read("views/#{self.class.to_s.underscore.chomp("_controller")}/#{template_name}.html.erb")
    content = ERB.new(f).result(binding)
    render_content(content, "text/html")
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type)
    raise if already_built_response?
    res.body = content 
    res.content_type = content_type
    @already_built_response = true
    session.store_session(res)
    flash.store_flash(res)
  end

  def session
    @session ||= Session.new(req)
  end
end