Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  # Draft!
  namespace :api, defaults: {format: :json} do
    devise_for :users
    resources :users

    # make sure to not have a general journals index
    resources :journals do
      resources :prompts
      resources :recurring_prompts
    end

    resources :recurring_prompts do
      resources :prompts
    end

    resources :prompts do
      resources :entries
    end

    resources :prompts
  end
end
