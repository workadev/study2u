Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  # devise_for :staffs
  devise_for :users

  draw("admin")

  namespace :api do
    draw("api/v1")
    draw("api/users/v1")
    # draw("api/staffs/v1")
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
