require 'rubygems'
require 'sinatra'


get "/" do
  "Hello from Sinatra!\nIt is now #{Time.now}\n"
end

