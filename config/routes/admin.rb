# frozen_string_literal: true

devise_for :admin, controllers: {
  sessions: "admin/sessions"
}, skip: [:passwords, :registrations]

devise_scope :admin do
  get   "admin/edit",  to: "admin/registrations#edit",   as: "edit_admin_registration"
  put   "admin",       to: "admin/registrations#update", as: "admin_registration"
  patch "admin",       to: "admin/registrations#update", as: ""

  namespace :admin do
    resources :admins do
      get   "search", to: "admins#index", on: :collection
      post  "search", to: "admins#index", on: :collection
    end

    resources :articles do
      get   "search", to: "articles#index", on: :collection
      post  "search", to: "articles#index", on: :collection
    end

    resources :dashboards, only: :index

    resources :roles do
      get   "search", to: "roles#index", on: :collection
      post  "search", to: "roles#index", on: :collection
    end

    resources :staffs do
      get   "search", to: "staffs#index", on: :collection
      post  "search", to: "staffs#index", on: :collection
    end

    resources :users do
      get   "search", to: "users#index", on: :collection
      post  "search", to: "users#index", on: :collection
    end

    resources :interests do
      get   "search", to: "interests#index", on: :collection
      post  "search", to: "interests#index", on: :collection
    end

    resources :institutions do
      get   "search", to: "institutions#index", on: :collection
      post  "search", to: "institutions#index", on: :collection
    end

    # resources :static_contents do
    #   get   "search", to: "static_contents#index", on: :collection
    #   post  "search", to: "static_contents#index", on: :collection
    # end

    resources :tiny_mce, only: [] do
      collection do
        post 'upload'
      end
    end

  end
end
