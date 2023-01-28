class ApplicationController < ActionController::Base

#<!-- #  <%= javascript_pack_tag 'application', 'data-turbolinks-track': 'reload' %> -->

  def hello
    render html: 'Hello World!'
  end
end
