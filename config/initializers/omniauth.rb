SETUP_PROC = lambda do |env| 
  request = Rack::Request.new(env)
  session = request.env['rack.session']
  session[:preauth_referrer] ||= request.referrer
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitch, ENV["TWITCH_CLIENT_ID"], ENV["TWITCH_CLIENT_SECRET"], scope: "channel:read:polls", setup: SETUP_PROC
end

