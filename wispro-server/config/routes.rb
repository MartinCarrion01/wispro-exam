Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"  
  namespace :api do
    namespace :v1 do
      resources :providers, only: %i[create] do
        collection do
          get :get_plans
        end
        member do
          get :get_token
        end
        resources :users, only: %i[create]
      end
      resources :plans, only: %i[create] do
        resources :subscription_requests, only: %i[create]
      end
      resources :subscription_requests, only: %i[index update] do
        collection do
          get :rejected_last_month
        end
      end
      resources :subscription_change_requests, only: %i[create update]
      resources :clients, only: %i[create] do
        collection do
          get :current
        end
      end
      resources :users, only: %i[create]
      resources :auth, only: [] do
        collection do
          post :login
        end
      end
    end
  end
end
