Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with 'rake routes'.
  # devise_scope :user do
  #   get 'users/oauth2/meetup' => 'users/omniauth_callbacks#meetup', as: :meetup_authorise
  #   post 'users/oauth2/meetup' => 'users/omniauth_callbacks#meetup', as: :meetup_authorise_post
  #   get 'users/oauth2/meetup/callback' => 'users/omniauth_callbacks#meetup', as: :meetup_authorise_callback
  #   post 'users/oauth2/meetup/callback' => 'users/omniauth_callbacks#meetup', as: :meetup_authorise_callback_post
  # end

  # You can have the root of your site routed with 'root'
  root 'welcome#index'

  get 'welcome/change_plan' => 'welcome#change_plan'

  get 'gocardless/mandate_and_payment'

  get 'gocardless/complete_mandate'

  get 'gocardless/cancel'

  resources :stripe_charges, only: [:new, :create]

  resources :events do
    get :rsvp
  end

  devise_for :users, :controllers => { :omniauth_callbacks => 'users/omniauth_callbacks' }
  resources :users, only: [:show, :edit, :update]

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
