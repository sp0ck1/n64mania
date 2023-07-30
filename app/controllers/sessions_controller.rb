class SessionsController < ApplicationController
  def new
    render :new
  end

  def create
    user_info = request.env['omniauth.auth']

    puts user_info
    render html: user_info
    raise user_info # Your own session management should be placed here.
  end
end