Rails.application.routes.draw do
  devise_for :users
  resources :messages
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "calendars#index"
  post "calendars/year/:year/month/:month" => "calendars#change"
  get "messages_parts/year/:year/month/:month/day/:day" => "messages#show_parts"
end
