Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  namespace :api do
    namespace :v1 do
      
      resources :providers, only: %i[create] do
        member do
          get :get_token
        end
        collection do
          get :get_plans
        end
      end
      
      resources :plans, only: %i[create] do
        resources :subscription_requests, only: %i[create]
      end
      
      resources :subscription_requests, only: %i[index] do
        member do
          put :update_status
          patch :update_status
        end
        collection do
          get :rejected_last_month
        end
      end
      
      resources :subscription_change_requests, only: %i[create] do
        member do
          put :update_status
          patch :update_status
        end
      end
      
      resources :clients, only: %i[create] do
        collection do
          get :current
        end
      end
      
      resources :auth, only: [] do
        collection do
          post :login
        end
      end
    end
  end
end
