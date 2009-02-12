require 'pp'

require 'rubygems'
require 'json'
require 'mq'
require 'rack'

require 'rack_of_rabbit'

#use Rack::ShowExceptions
#use Rack::ShowStatus
#use Rack::Reloader
#
run RackOfRabbit.new