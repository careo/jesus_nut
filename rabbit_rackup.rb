require 'rubygems'

#require "#{File.dirname(__FILE__)}/easy_sin"

require 'rubygems'
require 'mq'
require 'json'
require 'uuid'

require 'rabbited_sinatra'

EM.run {

  def log *args
    p args
  end
  
  amq = MQ.new
  #amq.queue(UUID.generate,:auto_delete => true).bind(amq.topic('requests',:auto_delete => true)).subscribe{ |info,request|
  amq.queue("rabbit_rackup",:auto_delete => true).subscribe{ |info,request|
    env = JSON.parse(request)

    # Massage some rack values back into shape
    input = env.delete 'rack.input'
    env['rack.input'] = StringIO.new(input)

    #resp = [200, {'Content-Type' => 'text/plain'}, "Oh, Hai!"]
    sinatra = Sinatra::Application.new
    resp = sinatra.call(env)
    if info.reply_to
      amq.queue(info.reply_to).publish(resp.to_json, :key => info.reply_to, :message_id => info.message_id)
    end
    

  }
  
}
