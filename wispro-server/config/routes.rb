Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"  
  namespace :api do
    namespace :v1 do
      
      namespace :admin do
        resources :plans, only: %i[create] 

        resources :subscription_requests, only: %i[update] 

        resources :subscription_change_requests, only: %i[update]
      end

      resources :providers, only: %i[create] do
        resources :users, only: %i[create]
      end
      
      resources :plans, only: %i[] do
        resources :subscription_requests, only: %i[create]
      end

      resources :subscription_requests, only: %i[index] do
        collection do
          get :rejected_last_month
        end
      end

      resources :subscription_change_requests, only: %i[create]

      resources :users, only: %i[create]

      resources :auth, only: [] do
        collection do
          post :login
        end
      end
    end
  end
end
