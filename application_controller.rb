require 'dotenv/load'
require 'bundler'
require 'steam-api'
Bundler.require

require_relative 'models/model.rb'

class ApplicationController < Sinatra::Base

  get '/' do
    erb :index
  end
  post '/results' do
    erb :results
  end
end
