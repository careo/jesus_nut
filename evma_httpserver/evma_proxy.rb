require 'rubygems'
require 'eventmachine'
require 'evma_httpserver'
require 'em-http'

class MyHttpServer < EM::Connection
  include EM::HttpServer

  def initialize
    @servers  = [
      "http://localhost:4567/",
      "http://localhost:4568/",
      "http://localhost:4569/",
      "http://localhost:4570/",
      "http://localhost:4571/"
    ]
  end

  def uri
    @servers[rand(@servers.length)]
  end

  def process_http_request
    response = EM::DelegatedHttpResponse.new(self)

    http = EventMachine::HttpRequest.new(uri.to_s).get
    http.callback {
      headers = http.response_header
      content = http.response

      response.status = 200
      response.content_type "text"
      response.content = content
      response.send_response
    }
  end

end

EM.run{
  EM.kqueue
  EM.start_server '127.0.0.1', 8082, MyHttpServer
}

