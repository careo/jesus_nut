require 'rubygems'
require 'sinatra'


get "/" do
  "Hello from Sinatra!<br/>It is now #{Time.new}"
end

