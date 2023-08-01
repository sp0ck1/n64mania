class SessionsController < ApplicationController
  def new
    render :new
  end

  def create
   begin
    user_info = request.env['omniauth.auth']
    twitch_nickname = user_info['info']['nickname']
    uid = user_info['uid']
    
    credentials = user_info['credentials']
    token = credentials['token']
    expires_at = credentials['expires_at']
    refresh_token = credentials['refresh_token']

    puts "Hello, #{twitch_nickname}!"
   
    player = Player.find_by_name(twitch_nickname)
    unless player
      player = Player.find_by_stream(twitch_nickname)
    end

    if player
      redirect_to player_path(player.id) # Send to their page if they are recognized
    else 
      render "players/index" # If no associated player with twitch name
    end

  rescue => e
    bt = e.backtrace
    message = e.message
  #  binding.pry
  end

    #raise user_info # Your own session management should be placed here.
  end
end