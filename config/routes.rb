Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  devise_for :users, skip: [:passwords, :registrations, :sessions, :confirmations]

  concern :admin_feature do
    resources :admins, controller: "/admin/admins" do
      get   "search", to: "/admin/admins#index", on: :collection
      post  "search", to: "/admin/admins#index", on: :collection
    end

    resources :articles, controller: "/admin/articles" do
      get   "search", to: "/admin/articles#index", on: :collection
      post  "search", to: "/admin/articles#index", on: :collection
    end

    resources :dashboards, only: :index, controller: "/admin/dashboards"

    resources :roles, controller: "/admin/roles" do
      get   "search", to: "/admin/roles#index", on: :collection
      post  "search", to: "/admin/roles#index", on: :collection
    end

    resources :staffs, controller: "/admin/staffs" do
      get   "search", to: "/admin/staffs#index", on: :collection
      post  "search", to: "/admin/staffs#index", on: :collection
    end

    resources :users, controller: "/admin/users" do
      get   "search", to: "/admin/users#index", on: :collection
      post  "search", to: "/admin/users#index", on: :collection
    end

    resources :interests, controller: "/admin/interests" do
      get   "search", to: "/admin/interests#index", on: :collection
      post  "search", to: "/admin/interests#index", on: :collection
    end

    resources :institutions, controller: "/admin/institutions" do
      get   "search", to: "/admin/institutions#index", on: :collection
      post  "search", to: "/admin/institutions#index", on: :collection
    end

    # resources :static_contents do
    #   get   "search", to: "static_contents#index", on: :collection
    #   post  "search", to: "static_contents#index", on: :collection
    # end
  end

  resources :tiny_mce, only: [] do
    collection do
      post 'upload' => "tiny_mce#upload"
    end
  end

  draw("admin")
  draw("staff")

  namespace :api do
    draw("api/v1")
    draw("api/users/v1")
    # draw("api/staffs/v1")
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
