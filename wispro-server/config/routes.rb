Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  namespace :api do
    namespace :v1 do
      resources :providers do
        member do
          resources :plans, param: :plan_id do
            member do
              post :require
            end
          end
        end
      end
      resources :clients, only: %i[create]
      resources :auth, only: [] do
        collection do
          post :login
        end
      end
    end
  end
end
