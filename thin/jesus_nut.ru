require 'pp'

require 'rubygems'
require 'json'
require 'mq'
require 'rack'

require "#{File.dirname(__FILE__)}/jesus_nut"

#use Rack::ShowExceptions
#use Rack::ShowStatus
#use Rack::Reloader

run JesusNut.new