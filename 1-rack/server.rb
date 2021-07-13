# frozen_string_literal: true

require 'rack'
require './router'

class Server
  def initialize(router)
    @router = router
  end

  def call(env)
    @router.handle Rack::Request.new(env)
  end
end

Rack::Handler::WEBrick.run Server.new Router.new
