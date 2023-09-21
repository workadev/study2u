namespace :v1 do
  get '/presign' => 'presigns#new' unless Rails.env.development? || Rails.env.test?

  resources :articles, only: [:index, :show]

  resources :institutions, only: [:index, :show] do
    collection do
      get   "recommendations"
      post  "compares"
    end

    member do
      post  "shortlist"
      post  "unshortlist"
    end
  end

  resources :interests, only: [:index, :show]

  resources :mentors, only: [:index, :show]

  resources :study_levels, only: [:index, :show]
end
