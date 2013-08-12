ActualFIT::Application.routes.draw do


  resources :users  do
    get 'get_profile_picture', on: :member
    put 'grant_role', on: :member
    put 'revoke_role', on: :member
  end
  resources :sessions, only: [:new, :create, :destroy]
  resources :inspections do
    get 'download_artifacts', on: :member
    get 'upload_remarks', on: :member
    get 'download_remarks', on: :member
    post 'upload_remarks', on: :member
    put 'change_status', on: :member
    put 'add_user', on: :member
    put 'remove_user', on: :member
    put 'change_deadline', on: :member
    resources :artifacts
    resources :remarks
    resources :chat_messages, only: [:index, :create]
  end
  resources :campaigns
  root to: 'main_page#home'
  match '/remarks_template', to: 'inspections#download_remarks_template', via: :get
  match '/assignments_template', to: 'campaigns#download_template', via: :get
  match '/new_inspection', to: 'inspections#new'
  match '/new_campaign', to: 'campaigns#new'
  match '/signup', to: 'users#new'
  match '/signin', to: 'sessions#new'
  match '/signout', to: 'sessions#destroy', via: :delete
  #match '/upload_file', to: 'artifacts#new'
  # get "artifacts/artifacts"

  # get "chat/chat"

  get "main_page/home"

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

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
