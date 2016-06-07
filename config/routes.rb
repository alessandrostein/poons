Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/webhook', to: 'application#setup'
  post '/webhook', to: 'application#receive'
end
