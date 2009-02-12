require 'rubygems'
require 'sinatra'

set :environment,       :production
set :port,      4567
disable :run, :reload

require 'easy_sin'

run Sinatra::Application