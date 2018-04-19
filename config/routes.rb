Rails.application.routes.draw do
  root 'top#index'

  namespace :admin do
    get '/' => 'dashboards#index'
    get '/sign_in' => 'sessions#new'
    post '/sign_in' => 'sessions#create'
    get '/sign_out' => 'sessions#destroy'
    resources :dashboards, only: [:index]
    resources :admin_users, except: [:show]
    resources :users
    resources :information
    resources :corporations do
      resources :corporation_users
      resources :user_contracts
      resources :plans
      resources :facilities, only: [] do
        resources :facility_plans, only: [:new, :create, :destroy]
        resources :facility_temporary_plans, only: [:new, :edit, :create, :update, :destroy] do
          collection do
            get :resources
            get :events
          end
        end
      end
      resources :shops, except: [:index] do
        resources :facilities, except: [:index] do
          resources :facility_keys, except: [:index]
        end
      end
    end
  end

  resource :user
  get '/sign_in' => 'sessions#new'
  post '/sign_in' => 'sessions#create'
  get '/sign_out' => 'sessions#destroy'
  resources :sessions, only: [:new, :create, :destroy] do
    collection do
      get :reminder
      post :post_reminder
      get 'reset_password/:token', to: 'sessions#reset_password', as: 'reset_password'
      patch 'update_password/:token', to: 'sessions#update_password', as: 'update_password'
    end
  end
  resources :shops, only: [:index, :show]
  resources :facilities, only: [:index, :show]
  resources :spot_facilities, only: [:index], controller: 'facilities'
  resources :plans
  resources :user_contracts, only: [:new, :create]

  post '/fetch_corporation_ids' => 'corporations#fetch_corporation_ids'
  # 法人メニュー
  resource :corporation, only: [:show, :edit, :update]
  # resources :users, only: [:index, :new, :create, :show]
  # resources :plans, except: [:show]
  # resources :shops, except: [:destroy] do
  #   resources :facilities, except: [:index]
  # end
end
