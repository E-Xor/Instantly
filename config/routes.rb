Rails.application.routes.draw do

  root to: 'calendly_feed#index'

  post '/webhook_catch', to: 'calendly_feed#webhook_catch'

end
