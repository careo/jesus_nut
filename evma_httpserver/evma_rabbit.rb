require 'rubygems'
require 'eventmachine'
require 'evma_httpserver'
require 'mq'
require 'uuid'

class MyHttpServer < EM::Connection
include EM::HttpServer

  def initialize
    @reply_to = UUID.generate
    @pending = Hash.new
    @mq = MQ.new
    @requests = @mq.queue('rabbit_rackup',:auto_delete => true)
    @setup = true
    @mq.queue(@reply_to).subscribe { |info, response|
      #resp = JSON.parse response
      resp = Marshal.load response
      callback = @pending.delete info.message_id

      callback.status = resp[0]
      callback.content_type resp[1]["Content-Type"]
      callback.content = resp[2]
      callback.send_response
    }
    @id = 1
  end
  
  # stub out an env
  def env
    {
      "REQUEST_METHOD" => "GET",
      "SCRIPT_NAME" => "",
      "PATH_INFO" => "/",
      "QUERY_STRING" => "",
      "SERVER_NAME" => "localhost", 
      "SERVER_PORT" => "8080",
      "rack.version" => [0,1],
      "rack.url_scheme" => "http",
      "rack.input" => "",
      "rack.errors" => "",
      "rack.multithread" => true,
      "rack.multiprocess" => true,
    }
  end

  def process_http_request
    # the ID of the request
    #message_id = UUID.generate
    @id += 1
    message_id = @id.to_s
    #@requests.publish(env.to_json, :message_id => message_id, :reply_to => @reply_to)
    @requests.publish(Marshal.dump(env), :message_id => message_id, :reply_to => @reply_to)

    response = EM::DelegatedHttpResponse.new(self)
    @pending[message_id] = response
    
    # Set a timeout of 60 seconds for a response
    #EM.add_timer(60) {
    #  callback = @pending.delete message_id
    #  if callback # we won't still have this, but if we do....
    #    callback.call [500, {'Content-Type' => 'text/plain'}, "Something broke."]
    #  end
    #}

  end

end

EM.run{
  EM.kqueue
  EM.start_server '0.0.0.0', 8080, MyHttpServer
}



