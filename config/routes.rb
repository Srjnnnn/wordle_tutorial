Rails.application.routes.draw do
  resources :words
  resources :games do
    member do
      post 'try'
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
