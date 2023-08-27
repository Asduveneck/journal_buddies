Rails.application.routes.draw do
  # devise_for :users
  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  },
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  namespace :api, defaults: {format: :json} do

    # get 'current_user', to: 'current_users#show'
    resource :current_users, only: %i[show update] do
      get 'journals', to: '#journals'
    end

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
