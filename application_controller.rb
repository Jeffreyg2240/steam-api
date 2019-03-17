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
  
  post '/result' do
    begin
        puts @steamID = params[:steam_id]
        @steam_data = user(@steamID)
        @steamID = @steam_data[1].to_i
        @steam_time = hoursplayed(@steamID)
        @games = steam_games(@steamID)
        @steam_bans = bans(@steamID)
        puts @steamID
      rescue
        @steamID = "Invalid ID"
      end
      erb :result
    end
end
