Rails.application.routes.draw do
  resources :submissions do 
    member do
      put "like", to: "submissions#upvote"
      put "dislike", to: "submissions#downvote"
    end
  end
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'submissions#index', type: :points

  get 'news' => 'submissions#index', as: :news_menu, type: :points
  get 'newest' => 'submissions#index', as: :newest_menu, type: :created_at
  get 'ask' => 'submissions#index', as: :ask_menu, type: :ask
  get 'item' => 'submissions#show', as: :item

  get 'auth/:provider/callback', to: 'sessions#create', as: :auth
  get 'auth/failure', to: redirect('/')
  get 'users/:uid' => 'users#index'
  get 'logout', to: 'sessions#destroy'
end
