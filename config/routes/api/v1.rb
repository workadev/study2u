namespace :v1 do
  get '/presign' => 'presigns#new' unless Rails.env.development? || Rails.env.test?
end
