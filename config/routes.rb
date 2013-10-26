GenericForums::Application.routes.draw do
  devise_for :users

  resources :categories

  root to: "categories#index"

  namespace :api, defaults: {format: :json} do
    # our api stuff will go here...
  end
end
