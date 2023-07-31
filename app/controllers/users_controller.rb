class UsersController < ApplicationController

  def create
    @user = User.new(user_params)
    if @user.save
      puts "Successful User Creation"
    else puts "It didn't work"
    end
  end

  private

  def user_params
    params.require(:user).permit(:uid, :twitch_nickname, :token)
  end

end