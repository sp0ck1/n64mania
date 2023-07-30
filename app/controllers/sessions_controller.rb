class SessionsController < ApplicationController
  def new
    render :new and return
  end

  def create
   begin
    user_info = request.env['omniauth.auth']
    nickname = user_info['info']['nickname']

    puts "Hello, #{nickname}!"
   
    player = Player.find_by_name(nickname)
    puts player
    if player.id.nil? 
      render "players/index" 
    else 
      redirect_to player_path(player.id)
    end

  rescue => e
    bt = e.backtrace
    message = e.message
  #  binding.pry
  end

    #raise user_info # Your own session management should be placed here.
  end
end