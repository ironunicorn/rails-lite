require 'json'
require 'webrick'


class Session
  def initialize(req)
    session = req.cookies.find { |cookie| cookie.name == '_rails_lite_app' }
    @session = session ? JSON.parse(session.value) : {}
  end

  def [](key)
    @session[key]
  end

  def []=(key, val)
    @session[key] = val
  end

  def store_session(res)
    new_cookie = WEBrick::Cookie.new('_rails_lite_app', @session.to_json)
    new_cookie.path = "/"
    res.cookies << new_cookie
  end
end
