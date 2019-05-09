Rails.application.routes.draw do

  unless Rails.env.production?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  root 'top#index'

  namespace :admin do
    get '/' => 'dashboards#index'
    get '/sign_in' => 'sessions#new'
    post '/sign_in' => 'sessions#create'
    get '/sign_out' => 'sessions#destroy'
    resources :dashboards, only: [:index]
    resources :admin_users, except: [:show]
    resources :users do
      resources :personal_identifications
    end
    resources :user_corps do
      resources :users, controller: 'users'
    end
    resources :information
    resources :corporations do
      resources :corporation_users
      resources :user_contracts
      resources :plans
      resources :facilities, only: [] do
        member do
          get :events
        end
        resources :facility_plans, only: [:new, :create, :destroy]
        resources :facility_dropin_plans, only: [:new, :edit, :create, :update, :destroy] do
          collection do
            get :resources, format: 'json'
            get :events, format: 'json'
          end
        end
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
    resources :reservations do
      collection do
        get :payment
        get :confirm
      end
    end
    resources :dropin_reservations do
      collection do
        get :payment
        get :confirm
      end
    end
    resources :billings, only: [:index, :show]
  end

  resource :user do
    collection do
      get 'new/:parent_token', to: 'users#new', as: 'new_parent_token'
    end
  end
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
  resources :shops, only: [:index, :show] do
    resources :facilities, only: [:new, :create], controller: 'shops/facilities'
  end
  get '/shops/:shop_id/facilities/:id/events' => 'shops/facilities#events'
  resources :facilities, only: [:index, :show]
  resources :reservations, only: [:index, :show, :new, :create, :destroy] do
    collection do
      get :price
      get :dropin_spot
      get :spot
      post :confirm
      get :confirm
      post :credit_card
      get :thanks
    end
  end
  resource :personal_identification
  resources :dropin_reservations, only: [:index, :show, :new, :create, :destroy] do
    collection do
      get :plan
      get :dropin_spot
      post :confirm
      get :confirm
      post :credit_card
      get :thanks
    end
  end
  resources :plans
  resource :credit_card, only: [:new, :create, :show, :edit, :update]
  resources :invitations, only: [:index, :new, :create]
  resources :information, only: [:index, :show]

  post '/fetch_corporation_ids' => 'corporations#fetch_corporation_ids'
  # 法人メニュー
  namespace :corporation_manage do
    root 'dashboards#index'
    resources :shops, except: :index
    resources :plans
    resources :user_contracts
    resources :information
  end
  # resources :users, only: [:index, :new, :create, :show]
  # resources :plans, except: [:show]
  # resources :shops, except: [:destroy] do
  #   resources :facilities, except: [:index]
  # end
end
