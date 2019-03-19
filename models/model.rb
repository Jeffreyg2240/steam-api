require 'steam-api'
require 'steam_web_api'
require 'net/http'
require 'json'
require 'pp'
require 'dotenv/load'
Steam.apikey = '3AB7758DA2A0F8B637FFB2BCF49D10AE'
    def user(steam_id)
        #If the user input was the id or a customr id
        #sets steam_name to the username
        if (steam_id =~ /\A[-+]?[0-9]+\z/)
            steam_name = Steam::User.summary(steam_id.to_i)['personaname']
        else
            steam_id = Steam::User.vanity_to_steamid(steam_id)
            steam_name = Steam::User.summary(steam_id)['personaname']
        end
        begin
            steam_url = Steam::User.summary(steam_id.to_i)['profileurl']
            steam_avatar = Steam::User.summary(steam_id.to_i)["avatarfull"]
            steam_level = Steam::Player.steam_level(steam_id.to_i)
            steam = [steam_name, steam_id.to_i, steam_url, steam_avatar, steam_level]
        rescue 
             steam = ["Invalid Name","Invalid ID", "", "https://steamuserimages-a.akamaihd.net/ugc/885384897182110030/F095539864AC9E94AE5236E04C8CA7C2725BCEFF/","N/A"]
        end
        steam
    end
    #Total number of games the account owns
    def steam_games(steam_id)
        games = []
        game_time = []
        pairing = []
        total_games = Steam::Player.owned_games(steam_id)['games']
        Steam::Player.owned_games(steam_id)['games'].each{ |game_specs|
           game_time << game_specs['playtime_forever'].to_i/60
        }
        if game_time.length >= 50
           game_time = game_time[0..50]
           total_games = total_games[0..50]
        end
       
                #Total number of games the account owns
                #Tterates through each hash(game)
                total_games.each { |x|
                    #2nd API which is used to turn the game ID into itle
                    #'game' is a array of hashes of all of steam's games
                    game = JSON.parse(Net::HTTP.get(URI("https://api.steampowered.com/ISteamApps/GetAppList/v2/")))["applist"]["apps"].select { 
                        |app_id| 
                        if app_id['appid'] == x['appid']
                            games << app_id['name']
                            break
                        end
                    }
                }
                for i in 0...games.length do
                    pairing << {games[i] => game_time[i]} 
                end
        pairing
    end
    def bans(steam_id)
        sBans = []
        #Community Ban
        if Steam::User.bans(steam_id)['players'][0]['CommunityBanned'] == false
            sBans << "No"
        else
            sBans << "Yes"
        end
        #VAC Ban
        if Steam::User.bans(steam_id)['players'][0]['VACBanned'] == false 
            sBans << "No"  
        else
            sBans << "Valve Allow Cheats"
        end
        #Non-Vac Game Ban (aka Game Ban)
        if Steam::User.bans(steam_id)['players'][0]['NumberOfGameBans'] <= 0
            sBans << "No"
        else
            sBans << "Yes"
        end
        #Trade Ban
        if Steam::User.bans(steam_id)['players'][0]['EconomyBan'] == "none"
            sBans << "No"
        else
            sBans << "Yes"
        end
        sBans
    end
    
    def steam_friend(steam_id)
        friend_array = []
        raw_Data = Steam::User.friends(steam_id)
        if raw_Data.length >=42
            raw_Data = raw_Data[0..42]
        end
         raw_Data.each{ |friendID|
            friend_array << user(friendID['steamid'])#''.to_i' took me 2 hours in the middle of the night to fix
        }
        friend_array
    end
    
    def hoursplayed(steam_id)   
        twoweek = 0
        hours = 0
        total_games = Steam::Player.owned_games(steam_id)["game_count"]
        # #Goes through every game and adds up all the total minutes played in the account
        Steam::Player.owned_games(steam_id)['games'].find_all{ |minutes_played| hours += minutes_played["playtime_forever"]}
        # #Divides minutes to get hours
        hours /= 60
        # #Goes through every game and adds up the total number of minutes played within the past 2 weeks
        Steam::Player.owned_games(steam_id)['games'].find_all{ |minutes_played| twoweek += minutes_played["playtime_2weeks"].to_i}#The "playtime_2weeks" was not a FixNum
        # #Divides minutes to get hours
        twoweek /= 60
        time = [hours, twoweek, total_games]
        time
    end
# puts steam_friend(user('IfUReadThisURLIHaveWastingUrTime')[1].to_i)
    # puts steam_friend(user('IfUReadThisURLIHaveWastingUrTime')[1].to_i)
# https://www.rubydoc.info/gems/steam-api/Steam/Player
#   <% @games.each do |game| %>
#              <%= game %>
#           <% end %>
# steam_id = Steam::User.vanity_to_steamid(steam_id)
    #Screenshot for example
    # https://steamcommunity.com/id/questionablegoblin