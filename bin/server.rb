require 'webrick'
require_relative '../lib/controller_base'
require_relative '../lib/router'
require_relative '../controllers/root_controller'
require_relative '../controllers/cats_controller'
require_relative '../controllers/humans_controller'
require_relative '../controllers/sessions_controller'
require_relative '../active_record/db_connection'

# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/HTTPRequest.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/HTTPResponse.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/Cookie.html

router = Router.new
router.draw do
  get Regexp.new("^/?$"), RootController, :root
  get Regexp.new("^/cats/?$"), CatsController, :index
  get Regexp.new("^/cats/new/?$"), CatsController, :new
  get Regexp.new("^/cats/(?<id>\\d+)/edit/?$"), CatsController, :edit
  get Regexp.new("^/cats/(?<id>\\d+)/?"), CatsController, :show
  post Regexp.new("^/cats$"), CatsController, :create
  put Regexp.new("^/cats/(?<id>\\d+)"), CatsController, :update
  delete Regexp.new("^/cats/(?<id>\\d+)"), CatsController, :destroy
  get Regexp.new("^/humans/new/?$"), HumansController, :new
  post Regexp.new("^/humans$"), HumansController, :create
  get Regexp.new("^/session/new/?$"), SessionsController, :new
  post Regexp.new("^/session$"), SessionsController, :create
  delete Regexp.new("^/session"), SessionsController, :destroy
end

server = WEBrick::HTTPServer.new(Port: 3000)
server.mount_proc('/') do |req, res|
  route = router.run(req, res)
end

trap('INT') { server.shutdown }
server.start
