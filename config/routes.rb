DatabaseProject::Application.routes.draw do
  get "pages/create"
  post "pages/submit"
   post "main/post_submit"
   post "main/add_comment"
   post "main/like_comment"
   post "main/like_post"
  post "pages/add"
  get "pages/add"
  get "pages/show"
  get "question/ask"
  post "question/ask"
  get "question/addAnswer"
  post "question/addAnswer"
  get "question/upvote"
  post "question/upvote"
  get "question/downvote"
  post "question/downvote"
  get "question/addAnswer"
  post "question/addAnswer"
  get "question/edit"
  post "question/edit"
  get "question/update"
  post "question/update"
  get "question/myquestions"
  post "question/myquestions"
  get "question/add"
  post "question/add"
  post "pages/comment"
  get "question/view"
  post "question/view"
  get "main/index"
  get "main/profile"
  post "main/index"
  get "main/logout"
  post "main/logout"
  get "main/update"
  post "main/update"
  post "main/profile"
  post "main/confirm"
  get "main/confirm"
  post "pages/pageLike"
   post "main/manageFriends"
  get "main/manageFriends"
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'main#index'

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
