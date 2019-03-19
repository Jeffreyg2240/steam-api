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
        @steamID = params[:steam_id].gsub(" ", "")
        #[username, steam id, steam URL, steam avatar]
        begin
          @steam_data = user(@steamID)
        rescue
          @steam_data = ["Invalid Name","Invalid ID", "", "https://steamuserimages-a.akamaihd.net/ugc/885384897182110030/F095539864AC9E94AE5236E04C8CA7C2725BCEFF/","N/A"]
        end
        @steamID = @steam_data[1].to_i
        
        #[total hours, hours within 2 weeks, Number of games]
        begin
          @steam_time = hoursplayed(@steamID)
        rescue
          @steam_time = ["Unknown/Private","Unknown/Private","Unknown/Private"]
        end
        
        #[{game = total time played}, {game = total time played}.....]
        begin
          @games = steam_games(@steamID)
        rescue
          @games = ["Private Profile" => "???"]
        end
        
        #[community ban, VAC ban, game ban, trade ban]
        begin
          @steam_bans = bans(@steamID)
        rescue
          @steam_bans =  ["N/A","N/A","N/A","N/A"]
        end
        
        #[username, steam id, steam URL, steam avatar, steam level]
        begin 
          @friends = steam_friend(@steamID)
        rescue
          @friends = [["Bob your imaginary friend","0107", "https://www.buzzfeed.com/erinfrye/all-new-friends", "https://steamuserimages-a.akamaihd.net/ugc/885384897182110030/F095539864AC9E94AE5236E04C8CA7C2725BCEFF/"]]
        end
      erb :result
    end
end