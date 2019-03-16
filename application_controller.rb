require 'dotenv/load'
require 'bundler'
require 'steam-api'
require 'pp'
Bundler.require

require_relative 'models/model.rb'

class ApplicationController < Sinatra::Base

  get '/' do

    erb :index
  end
  
  post '/results' do
    @steamV = params[:steam_id]
    @steam = SteamAPI.new(@steamV)
    @steam_cred = @steam.
    erb :results
  end
end
