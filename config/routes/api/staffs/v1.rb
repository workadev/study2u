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
        get     ''                => 'current#show'
        put     ''                => 'current#update'
        patch   ''                => 'current#update'
        put     'update/password' => 'current#update_password'
        patch   'update/password' => 'current#update_password'

        get     'articles'        => 'articles#index'
        get     'institutions'    => 'institutions#index'
        get     'mentors'         => 'mentors#index'
      end
    end

    resources :conversations, only: [:index, :show, :destroy] do
      collection do
        post  ':user_id'  => 'conversations#create'
      end

      member do
        get   "messages"  => 'messages#index'
      end
    end

    resources :presences, only: :index
  end
end
