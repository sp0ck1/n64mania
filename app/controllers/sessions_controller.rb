class SessionsController < ApplicationController
  def new
    render :new
  end

  def create
   begin
    
    user_info = request.env['omniauth.auth']
    user_info
    session[:twitch_nickname] = user_info['info']['nickname']
    twitch_nickname = session[:twitch_nickname]
    session[:uid] = user_info['uid']
    
    credentials = user_info['credentials']
    session[:token] = credentials['token']
    session[:expires_at] = credentials['expires_at']
    session[:refresh_token] = credentials['refresh_token']
    session[:user] = User.find_by_uid(session[:uid]) if session[:uid]

    flash[:welcome] = "Hello, #{twitch_nickname}! You have been successfully logged in."
   
    player = Player.find_by_name(twitch_nickname)
    unless player
      player = Player.find_by_stream(twitch_nickname)
    end

    if player
      redirect_to player_path(player.id) # Send to their page if they are recognized
    else 
      
      render "players/index" # If no associated player with twitch name, need to ask user who they are. Need easy way to add in player id/user id afterward
    end

    rescue => e
      bt = e.backtrace
      message = e.message
    end

    #raise user_info # Your own session management should be placed here.
  end

  def destroy
    session[:uid] = nil
    flash[:success] = "You have logged out"
    
    redirect_to request.referrer
  end
end # Class end

