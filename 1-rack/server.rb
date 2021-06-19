# frozen_string_literal: true

require 'rack'

class Router
  def initialize
    @routes_settings = [
      {
        handler: -> { [200, {}, ['Home']] },
        path: '/',
        method: 'get'
      },
      {
        handler: -> { [200, {}, ['Hello']] },
        path: '/hello',
        method: 'get'
      },
      {
        handler: -> { [200, {}, ['Not found']] }
      }
    ]
  end

  def handle(request)
    result = @routes_settings.find do |route|
      route if match_by_method?(request, route) && match_by_path?(request, route)
    end
    result[:handler].call
  end

  def match_by_path?(request, route)
    !route[:path] || request.path_info == route[:path]
  end

  def match_by_method?(request, route)
    !route[:method] || request.request_method.downcase == route[:method].downcase
  end
end

class Server
  def initialize(router)
    @router = router
  end

  def call(env)
    @router.handle Rack::Request.new(env)
  end
end

Rack::Handler::WEBrick.run Server.new Router.new
