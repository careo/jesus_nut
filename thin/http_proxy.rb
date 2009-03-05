require 'rubygems'
require 'em-http'

class HttpProxy

  # This is a template async response. N.B. Can't use string for body on 1.9
  AsyncResponse = [-1, {}, []].freeze

  def log *args
    p [Time.now, *args]
  end
  
  # Do only non-EM things here, because we won't be inside EM.run yet....
  def initialize
    @setup = false
    @servers  = [
      "http://localhost:4567/", 
      "http://localhost:4568/", 
      "http://localhost:4569/",
      "http://localhost:4570/",
      "http://localhost:4571/"
    ]
    #EventMachine.set_max_timers 1_000_000
  end
  
  # Need a separate "initialize" step that happens after Thin and company
  # are fully started. This is it.
  def setup
    EM.kqueue if EM.kqueue?
    EM.epoll if EM.epoll?
    @setup = true
  end
  
  # Handle the request
  def call env
    setup unless @setup

    request_uri = env['REQUEST_URI']
    
    http = EventMachine::HttpRequest.new(uri.to_s).get
    http.callback {
      headers = http.response_header
      content = http.response
      env['async.callback'].call([
        200,
        headers,
        content
      ])
    }

    AsyncResponse
  end

  def uri
    @servers[rand(@servers.length)]
  end
  
  
end