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
        @steamID = params[:steam_id]
        #[user name, steam id, steam URL, steam avatar]
        @steam_data = user(@steamID)
        @steamID = @steam_data[1].to_i
        #[total hours, hours within 2 weeks, Number of games]
        @steam_time = hoursplayed(@steamID)
        #[{game = total time played}, {game = total time played}.....]
        @games = steam_games(@steamID)
        #[community ban, VAC ban, game ban, trade ban]
        @steam_bans = bans(@steamID)
      rescue
        @steamID = "Invalid ID"
        @steam_data = ["???","???", "???", "https://steamuserimages-a.akamaihd.net/ugc/885384897182110030/F095539864AC9E94AE5236E04C8CA7C2725BCEFF/"]
        @steam_bans = ["N/A","N/A","N/A","N/A"]
        @steam_time = ["???","???", "???"]
        @games = ["???" => "???"]
      end
      erb :result
    end
end