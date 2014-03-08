Airbrake.configure do |config|
  config.api_key = '994e8bb8346447d3a1dcf435343fdf38'
  config.host    = 'errbit.evrone.ru'
  config.port    = 80
  config.secure  = config.port == 443
end
