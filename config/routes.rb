Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  # Draft!
  namespace :api, defaults: {format: :json} do
    devise_for :users
    resources :users do
      # resources :journals_users
    end

    resources :journals
    resources :entries
    resources :prompts
  end
end
