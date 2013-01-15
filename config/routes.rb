Technews::Application.routes.draw do

  require 'sidekiq/web'
  constraint = lambda { |request| request.env["warden"].authenticate? && request.env['warden'].user.is_admin? }
  constraints constraint do
    mount Sidekiq::Web => '/queue'
  end

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  devise_for :users

  root :to => 'categories#home'
  
  resources :feed_types
  
  resources :feed_sites do
    resources :feed_entries
    resources :category
    collection do
      get 'refresh_xluriwaplezx'
    end
  end
  
  resources :feed_entries do
    resources :feed_site
  end
  
  resources :categories do
    resources :feed_sites
    collection do
      get 'home'
    end
  end
  
  resources :users do
    resources :feed_sites
    resources :own_categories
    resources :buildings
  end
  
  # devise_for :users
  
  # resource :account, :controller => 'users'
  # resources :users
  # resource :user_session
  # match 'login', 'user_sessions#new', :as => :login
  # match 'logout', 'user_sessions#destroy', :as => :logout
  # match 'signup', 'users#new', :as => :signup
  # match 'register', 'users#new', :as => :register
  
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

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with 'root'
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with 'rake routes'

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
