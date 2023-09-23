namespace :staffs do
  namespace :v1 do
    devise_scope :user do
      post    'sign_up'       => 'registrations#create'
      get     'confirmation'  => 'confirmations#show'
      post    'confirmation'  => 'confirmations#create'
      post    'sign_in'       => 'sessions#create'
      post    'refresh_token' => 'sessions#refresh_token'
      delete  'sign_out'      => 'sessions#destroy'
      resources :reset_passwords, only: :create do
        collection do
          get   "" => 'reset_passwords#edit'
          patch "" => 'reset_passwords#update'
          put   "" => 'reset_passwords#update'
        end
      end
    end

    resources :current, only: [] do
      collection do
        get     ''  => 'current#show'
        put     ''  => 'current#update'
        patch   ''  => 'current#update'
      end
    end

    resources :conversations, only: [:index, :create, :show] do
      member do
        get "messages" => 'messages#index'
      end
    end
  end
end
