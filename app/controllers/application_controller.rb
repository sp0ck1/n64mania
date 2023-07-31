class ApplicationController < ActionController::Base

  helper_method :current_user, :logged_in?
#<!-- #  <%= javascript_pack_tag 'application', 'data-turbolinks-track': 'reload' %> -->

  def hello
    render html: 'Hello World!'
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  def logged_in?
    !!current_user
  end
  def require_user
    if !logged_in?
      flash[:danger] = "You must be logged in to perform that action"
      redirect_to root_path
     end
  end

end
