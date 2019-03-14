# Steam.apikey = ENV["STEAM_API_KEY"]
require 'steam-api'
require 'steam_web_api'
require 'net/http'
require 'json'
# Steam.apikey = "39E89FF9B42249EF9DCD3483F61FBEA2"


# puts "input your steam ID:"
# steam_id = gets.chomp




# pp steam_games_id_converter = JSON.parse(Net::HTTP.get(URI("https://api.steampowered.com/ISteamApps/GetAppList/v2/")))["applist"]["apps"]

# puts 
# puts Steam::User.summary(76561198233872272)["avatar"]

# puts Steam::User.summary(76561198074931455)
# Steam::User.friends(steam_id).each {|friendID|
#     puts  Steam::User.summary(friendID['steamid'])['personaname']
# }

# # Total Games
# puts Steam::Player.owned_games(76561198233872272)
# pp steam_games_id_converter = JSON.parse(Net::HTTP.get(URI("https://api.steampowered.com/ISteamApps/GetAppList/v2/")))["applist"]["apps"].values_at(1)

#Total number of games the account owns
def steam_games(steam_id)
    games = []
    total_games = Steam::Player.owned_games(steamid)['games']
    #Total number of games the account owns
    puts Steam::Player.owned_games(steam_id)['game_count']
    #Tterates through each hash(game)
    steam_games.each { |x|
    #2nd API which is used to turn the game ID into itle
    #'game' is a array of hashes of all of steam's games
    game = JSON.parse(Net::HTTP.get(URI("https://api.steampowered.com/ISteamApps/GetAppList/v2/")))["applist"]["apps"].select { |app_id| 

        if app_id['appid'] == x['appid']
            games << ({app_id['name'] => app_id['appid']})
            break
        end
      }
    }
    games
end
def bans(steam_id)
    #Community Ban
    puts Steam::User.bans(steam_id)['players']['CommunityBanned']
    #VAC Ban
    puts Steam::User.bans(steam_id)['players']['VACBanned']
    #Non-Vac Game Ban (aka Game Ban)
    puts Steam::User.bans(steam_id)['players']['NumberOfGameBans']
    #Trade Ban
    puts Steam::User.bans(steam_id)['players']['EconomyBan']
end

def user(steam_id)
    #If the user input was the id or a customr id
    #sets steam_name to the username
    if(steam_id.is_a? Integer)
        steam_name = Steam::User.summary(steam_id)['personaname']
        steam_id = Steam::User.vanity_to_steamid(steam_name)
    else
        steam_id = Steam::User.vanity_to_steamid(steam_id)
        steam_name = Steam::User.summary(steam_id)['personaname']
    end
    steam_url = Steam::User.summary(steam_id)['profileurl']
    steam_avatar = Steam::User.summary(steam_id)["avatar"]
    puts steam = [steam_name, steam_id, steam_url, steam_avatar]
end
def hoursplayed(steam_id)
    twoweek = 0
    hours = 0
    game_list = Steam::Player.owned_games(steam_id)['games']
    # #Goes through every game and adds up all the total minutes played in the account
    Steam::Player.owned_games(steam_id)['games'].find_all{ |minutes_played| hours += minutes_played["playtime_forever"]}
    # #Divides minutes to get hours
     hours /= 60
    # #Goes through every game and adds up the total number of minutes played within the past 2 weeks
    Steam::Player.owned_games(steam_id)['games'].find_all{ |minutes_played| twoweek += minutes_played["playtime_2weeks"].to_i}#The "playtime_2weeks" was not a FixNum
    # #Divides minutes to get hours
    twoweek /= 60
    puts time = [hours, twoweek]
end

# https://www.rubydoc.info/gems/steam-api/Steam/Player

#extras

# puts Steam::Player.steam_level(76561198233872272)
# puts Steam::User.vanity_to_steamid("StrikeBattleDuty")
# puts Steam::User.groups(76561198233872272)


#Screenshot for example
# https://steamcommunity.com/id/questionablegoblin
#  user("IfUReadThisURLIHaveWastingUrTime")
 user("Cinderhelm")
#  hoursplayed(76561198123275551)
 
 