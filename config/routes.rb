GenericForums::Application.routes.draw do
  get "home/index", "home/about", "home/rules"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  resources :boards, :only => [:index] do
    resources :ropes, :path => "threads", :except => [:show] do
      resources :posts do
        get 'diff' => "posts#diff"
        post 'undelete' => "posts#undelete"
      end
      post 'undelete' => "ropes#undelete"
    end
    get "threads/:rope_id" => "posts#index"
  end
  get "boards/:board_id" => "ropes#index"
  resources :tags

  resources :users, :except => [:destroy] do
    resources :messages
    get 'read' => 'users#read'
  end

  resources :sessions, :only => [:new, :create, :destroy]
  get "sessions/delete"
  get "sessions/token"

  namespace :admin do
    root :to => "Dashboard#index"
    get "index"      => "Dashboard#index",
        "dash"       => "Dashboard#index",
        "dash/index" => "Dashboard#index"
  end

  #scope "api" do
  #  root :to => "Api#index"
  #  get "index"  => "Api#index"
  #  get "whoami" => "Api#whoami"
  #end

  get "api" => "Api#index"
  get "api/:action", :controller => "Api"

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'Boards#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
