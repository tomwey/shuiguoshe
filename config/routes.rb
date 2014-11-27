Rails.application.routes.draw do

  root 'home#index'

  devise_for :users, path: "account", controllers: {
    registrations: :account,
    sessions: :sessions,
  }
  post "account/update_private_token" => "users#update_private_token", as: 'update_private_token_account'
  
  resources :users do
    get :orders, on: :member
  end
  
  resources :products do
    resources :orders, only: [:new, :create]
  end
  
  # resources :orders
  
  resources :apartments, only: [:index]
  
  namespace :cpanel do
    root 'home#index'
    resources :site_configs, only: [:index, :edit, :create, :update, :destroy, :new]
    resources :products
    resources :users do
      member do
        patch :block
        patch :unblock
      end
    end
    resources :product_types
    resources :apartments do
      member do
        patch :open
        patch :close
      end
    end
  end
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
