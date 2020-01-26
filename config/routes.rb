Rails.application.routes.draw do
  devise_for :users
  resources :messages, expect[:index]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "calendars#index"
  post "calendars/year/:year/month/:month" => "calendars#change"
end
