require 'sidekiq/web'

Rails.application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'
  devise_for :bloggers
  devise_for :members, :controllers => { registrations: 'members/registrations' }
  get '/wp-login', to: redirect('/', status: 301)
  get '/therapists/wp-login.php', to: redirect('/', status: 301)
  get '/blog/index.php', to: redirect('/blog', status: 301)
  
  #Error Pages
  match "/404", :to => "errors#not_found", :via => :all
  match "/500", :to => "errors#internal_server_error", :via => :all

  match 'members/:id' => 'members#destroy', :via => :delete, :as => :admin_destroy_member

  get '/dashboard' => 'members#dashboard'
  get '/dashboard/upgrades' => 'members#upgrade_manager'
  get '/dashboard/payments' => 'members#payment_history'
  get '/admin' => 'members#admin'
  get '/admin/dashboard' => 'members#admin'
  get '/admin/listings' => 'members#listings'
  get '/admin/listings/search' => 'members#admin_search'
  get '/admin/claims' => 'members#claims'
  get '/admin/ratings' => 'members#ratings'
  get '/admin/members' => 'members#members'
  get '/admin/members/:id/profile' => 'members#profile', as: :member_profile
  get '/admin/cities/search' => 'admin/cities#search'
  get '/admin/categories/search' => 'admin/categories#search'

  # Admins
  namespace :admin do
    resources :bloggers, except: :show
    resources :cities, except: :show
    resources :members, only: [:new, :create]
    resources :categories
  end

  root to: 'pages#index'

  get '/listings' => 'listings#search', as: :search
  get '/listings/cities_of_state/:state_id' => 'listings#cities_of_state', as: :cities_of_state

  resources :listings do
    resources :ratings
    resources :claims
    resources :uploads
    resources :upgrades
  end

  get '/:location_data/:id' => 'listings#new_redirect', constraints: { location_data: /([^\/]*)\-[a-z]{2}/ }, as: 'listing_new_redirect'
  get '/:directory/:location_data/:id' => 'listings#show', constraints: { location_data: /([^\/]*)\-[a-z]{2}/ }, as: 'listing_by_directory_location_id'

  scope :directories, as: :search_directory do
    get '/:directory' => 'listings#search'
    get '/:directory/:state' => 'listings#search', as: :state
    get '/:directory/:state/:city' => 'listings#search', as: :state_city
  end

  scope :search do
    get '/' => 'listings#search', to: redirect('/listings', status: 301)
    get '/:directory', to: redirect('/directories/%{directory}', status: 301)
    get '/:directory/:state', to: redirect('/directories/%{directory}/%{state}', status: 301)
    get '/:directory/:state/:city', to: redirect('/directories/%{directory}/%{state}/%{city}', status: 301)
  end

  get '/category/:category_id' => 'listings#search'
  get '/alpha/:directory/:alpha' => 'listings#search'

  get '/edit_fields_update' => 'listings#edit_fields_update'
  get '/boost/:listing_id/:category_id' => 'listings#boost'
  get '/unboost/:listing_id/:category_id' => 'listings#unboost'

  post '/mailchimp_submit' => 'mailchimp#submit'


  resources :ratings

  resources :claims

  get 'claims/:id/approve' => 'claims#approve', as: :approve_claim
  get 'claims/:id/decline' => 'claims#decline', as: :decline_claim

  get 'ratings/:id/approve' => 'ratings#approve', as: :approve_rating
  get 'ratings/:id/decline' => 'ratings#decline', as: :decline_rating
  post 'ratings/add_comment' => 'ratings#add_comment', as: :add_comment

  devise_scope :member do
    get '/login' => 'devise/sessions#new'
    get '/logout' => 'devise/sessions#destroy'
    get '/register' => 'devise/registrations#new'
    get '/profile' => 'devise/registrations#edit'
  end

  post '/hook' => 'payments#hook'

  # Blaze::Engine & Sidekiq::Engine
  if Rails.env.production? || Rails.env.staging?
    authenticated :member, lambda { |member| member.is_administrator? } do
      mount Blazer::Engine, at: 'admin/blazer'
      mount Sidekiq::Web, at: '/sidekiq'
    end
  else
    mount Blazer::Engine, at: 'admin/blazer'
    mount Sidekiq::Web, at: '/sidekiq'
  end

  # Blog
  namespace :blog do
    get '/' => 'posts#index', as: :posts_index
    get ':id' => 'posts#show', as: :post_page
    resources :posts, except: [:index, :show]
  end
  get '/:directory', to: redirect('/directories/%{directory}', status: 301)
end