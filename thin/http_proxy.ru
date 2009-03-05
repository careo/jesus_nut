require 'pp'

require 'rubygems'
require 'json'
require 'rack'

require "#{File.dirname(__FILE__)}/http_proxy"

#use Rack::ShowExceptions
#use Rack::ShowStatus
#use Rack::Reloader

run HttpProxy.new