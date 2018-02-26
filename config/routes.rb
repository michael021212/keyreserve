Rails.application.routes.draw do
  root 'top#index'

  namespace :admin do
    get '/' => 'dashboards#index'
    get '/sign_in' => 'sessions#new'
    post '/sign_in' => 'sessions#create'
    get '/sign_out' => 'sessions#destroy'
    resources :dashboards, only: [:index]
    resources :admin_users, except: [:show]
    # resources :plans
    resources :users
    resources :corporations do
      resources :users, controller: 'corporations/users', except: [:index]
    end
  end

  resource :user, only: [:new, :create]
  namespace :users do
    get '/' => 'dashboards#index'
    get '/sign_in' => 'sessions#new'
    post '/sign_in' => 'sessions#create'
    get '/sign_out' => 'sessions#destroy'
    resources :sessions, only: [:new, :create, :destroy] do
      collection do
        get :reminder
        post :post_reminder
        get 'reset_password/:token', to: 'sessions#reset_password', as: 'reset_password_token'
        patch 'update_password/:token', to: 'sessions#update_password', as: 'update_password'
      end
    end
  end
end
