Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'front#index'

  match '/groups/:group_id/boards_from/:offset' => 'boards#boards_from_offset', via: :GET

  # match '/boards', to: 'board#index', via: :GET
  resources :groups do
    resources :boards
  end
  resources :users

  match '/boards/:board_id/comments' => 'boards#comments', via: :POST
  match '/boards/:board_id/comments/:id' => 'boards#comment_update', via: :PUT

  match '/boards/my' => 'boards#my', via: :GET
  match '/boards/popular' => 'boards#popular', via: :GET
  match '/boards/:id/like' => 'boards#like', via: :POST
  match '/boards/:id/dislike' => 'boards#dislike', via: :POST

  match '/users/signin' => 'users#signin', via: :POST
  match '/users/signup' => 'users#signup', via: :POST
  match '/users/change_nick_name' => 'users#change_nick_name', via: :POST
  
  match '/groups/select' => 'groups#select', via: :POST

  resources :comments
  match '/boards/:id/comments' => 'comments#board_comments', via: :GET

  match '/admin' => 'admin#signin', via: :GET
  match '/admin/main' => 'admin#main', via: :GET
  match '/admin/users' => 'admin#users', via: :GET
  match '/admin/boards' => 'admin#boards', via: :GET
  match '/admin/boards/new' => 'admin#board_new', via: :GET
  match '/admin/users/:id/boards' => 'admin#user_boards', via: :GET
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
