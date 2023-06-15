Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  # Draft!
  namespace :api, defaults: {format: :json} do
      devise_for :users, path: '', path_names: {
        sign_in: 'login',
        sign_out: 'logout',
        registration: 'signup'
      },
      controllers: {
        sessions: 'users/sessions',
        registrations: 'users/registrations'
      }

    # make sure to not have a general journals index
    resources :journals do
      resources :prompts
      resources :recurring_prompts
      # bulk actions on journals_users
      get 'journals_users', to: 'journals_users#index'
      post 'journals_users', to: 'journals_users#create'
      patch 'journals_users', to: 'journals_users#update'
      delete 'journals_users', to: 'journals_users#destroy'
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
