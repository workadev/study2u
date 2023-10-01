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

    resources :branches, except: :show, controller: "/admin/branches" do
      get   "search", to: "/admin/branches#index", on: :collection
      post  "search", to: "/admin/branches#index", on: :collection
    end

    resources :contacts, only: :index, controller: "/admin/contacts" do
      get   "search", to: "/admin/contacts#index", on: :collection
      post  "search", to: "/admin/contacts#index", on: :collection
    end

    resources :dashboards, only: :index, controller: "/admin/dashboards"

    resources :institutions, controller: "/admin/institutions" do
      get   "search", to: "/admin/institutions#index", on: :collection
      post  "search", to: "/admin/institutions#index", on: :collection
    end

    resources :interests, controller: "/admin/interests" do
      get   "search", to: "/admin/interests#index", on: :collection
      post  "search", to: "/admin/interests#index", on: :collection
    end

    resources :majors, controller: "/admin/majors" do
      get   "search", to: "/admin/majors#index", on: :collection
      post  "search", to: "/admin/majors#index", on: :collection
    end

    resources :roles, controller: "/admin/roles" do
      get   "search",   to: "/admin/roles#index",   on: :collection
      get   "actions",  to: "/admin/roles#actions", on: :collection
      post  "search",   to: "/admin/roles#index",   on: :collection
    end

    resources :staffs, controller: "/admin/staffs" do
      get   "search", to: "/admin/staffs#index", on: :collection
      post  "search", to: "/admin/staffs#index", on: :collection
    end

    resources :states, except: :show, controller: "/admin/states" do
      get   "search", to: "/admin/states#index", on: :collection
      post  "search", to: "/admin/states#index", on: :collection
    end

    resources :study_levels, except: :show, controller: "/admin/study_levels" do
      get   "search", to: "/admin/study_levels#index", on: :collection
      post  "search", to: "/admin/study_levels#index", on: :collection
    end

    resources :subscriptions, only: :index, controller: "/admin/subscriptions" do
      get   "search", to: "/admin/subscriptions#index", on: :collection
      post  "search", to: "/admin/subscriptions#index", on: :collection
    end

    resources :users, only: [:index, :show], controller: "/admin/users" do
      get   "search", to: "/admin/users#index", on: :collection
      post  "search", to: "/admin/users#index", on: :collection
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
    draw("api/staffs/v1")
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
