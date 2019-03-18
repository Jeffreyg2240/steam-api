require 'steam-api'
require 'steam_web_api'
require 'net/http'
require 'json'
require 'pp'
require 'dotenv/load'
Steam.apikey = '39E89FF9B42249EF9DCD3483F61FBEA2'

steam_games_id_converter = JSON.parse(Net::HTTP.get(URI("https://api.steampowered.com/ISteamApps/GetAppList/v2/")))["applist"]["apps"]

# # Total Games
# puts Steam::Player.owned_games(76561198233872272)
# pp steam_games_id_converter = JSON.parse(Net::HTTP.get(URI("https://api.steampowered.com/ISteamApps/GetAppList/v2/")))["applist"]["apps"].values_at(1)


    # #[user name, steam id, steam URL, steam avatar]
    # puts steam_data = user(steam_id)
    # if steam_data != "Invalid ID"
    #     steamID= steam_data[1].to_i
    #     #[{game = total time played}, {game = total time played}.....]
    #     puts gaming_pairs = steam_games(steamID)
    #     # [total hours, hours within 2 weeks, Number of games]
    #     puts hours = hoursplayed(steamID)
    #     #[community ban, VAC ban, game ban, trade ban]
    #     puts bans(steamID)
    # end
    def user(steam_id)
        #If the user input was the id or a customr id
        #sets steam_name to the username
        
        if (steam_id =~ /\A[-+]?[0-9]+\z/)
            steam_name = Steam::User.summary(steam_id.to_i)['personaname']
        else
            steam_id = Steam::User.vanity_to_steamid(steam_id)
            steam_name = Steam::User.summary(steam_id)['personaname']
        end
        steam_url = Steam::User.summary(steam_id.to_i)['profileurl']
        steam_avatar = Steam::User.summary(steam_id.to_i)["avatarfull"]
        steam = [steam_name, steam_id.to_i, steam_url, steam_avatar]
        steam
    end
    #Total number of games the account owns
    def steam_games(steam_id)
        games = []
        game_time = []
        pairing = []
        Steam::Player.owned_games(steam_id)['games'].each{ |game_specs|
           game_time << game_specs['playtime_forever'].to_i/60
        }
        total_games = Steam::Player.owned_games(steam_id)['games']
            #Total number of games the account owns
            #Tterates through each hash(game)
            total_games.each { |x|
                #2nd API which is used to turn the game ID into itle
                #'game' is a array of hashes of all of steam's games
                game = JSON.parse(Net::HTTP.get(URI("https://api.steampowered.com/ISteamApps/GetAppList/v2/")))["applist"]["apps"].select { |app_id| 
                    # puts app_id['appid']
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
         Steam::User.friends(steam_id).each{ |friendID|
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

    # puts steam_friend(user('CinderHelm')[1].to_i)
# https://www.rubydoc.info/gems/steam-api/Steam/Player
#   <% @games.each do |game| %>
#              <%= game %>
#           <% end %>
    #Screenshot for example
    # https://steamcommunity.com/id/questionablegoblin