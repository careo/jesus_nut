# Mostly just ezmobius's nanite example and somic's rabbitbal

require 'rubygems'
require 'mq'


class JesusNut

  # This is a template async response. N.B. Can't use string for body on 1.9
  AsyncResponse = [-1, {}, []].freeze

  def log *args
    p [Time.now, *args]
  end
  
  # Do only non-amqp things here, because we won't be inside EM.run yet....
  def initialize
    @setup = false
    @reply_to = UUID.generate
    @pending = Hash.new
  end
  
  # Need a separate "initialize" step that happens after Thin and company
  # are fully started. This is it.
  def setup
    EM.kqueue
    #AMQP.logging = true
    @mq = MQ.new
    @requests = @mq.queue('jesus_nut',:auto_delete => true)
    @setup = true
    @mq.queue(@reply_to).subscribe { |info, response|
      resp = Marshal.load response
      callback = @pending.delete info.message_id
      callback.call resp
    }
    @id = 1
  end
  
  # Handle the request
  def call env
    setup unless @setup

    # scrub out the things that'll break serialization
    errors = env.delete 'rack.errors'
    input = env.delete('rack.input')
    async_callback = env.delete 'async.callback'
    env['rack.input'] = input.to_s
    
    # the ID of the request
    @id += 1
    message_id = @id.to_s
    
    
    #@requests.publish(env.to_json, :message_id => message_id, :reply_to => @reply_to)
    @requests.publish(Marshal.dump(env), :message_id => message_id, :reply_to => @reply_to)
    @pending[message_id] = async_callback
    
    # Set a timeout of 60 seconds for a response
    #EM.add_timer(60) {
    #  callback = @pending.delete message_id
    #  if callback # we won't still have this, but if we do....
    #    callback.call [500, {'Content-Type' => 'text/plain'}, "Something broke."]
    #  end
    #}

    AsyncResponse
  end

end