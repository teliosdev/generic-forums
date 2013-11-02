GenericForums::Application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'devise/custom_registrations'
  }


  resources :boards, as: :categories, controller: 'categories',
    only: [:index, :show] do
    resources :threads, as: :ropes, controller: 'ropes',
      shallow: true, except: [:index] do
      resources :posts, shallow: true, except: [:index]
    end
  end

  root to: "categories#index"

  mount GenericForums::API => "/api"
end
