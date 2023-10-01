namespace :users do
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
        get     ''                    => 'current#show'
        put     ''                    => 'current#update'
        patch   ''                    => 'current#update'
        put     'update/interests'    => 'current#update_interests'
        patch   'update/interests'    => 'current#update_interests'
        put     'update/shortlists'   => 'current#update_shortlists'
        patch   'update/shortlists'   => 'current#update_shortlists'
        put     'update/password'     => 'current#update_password'
        patch   'update/password'     => 'current#update_password'
      end
    end

    resources :conversations, only: [:index, :show, :destroy] do
      collection do
        post  ':staff_id' => 'conversations#create'
      end

      member do
        get   "messages"  => 'messages#index'
      end
    end

    resources :presences, only: :index
  end
end
