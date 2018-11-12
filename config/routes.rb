Rails.application.routes.draw do
  resources :comments do
    member do
      put "like", to: "comments#upvote"
      put "dislike", to: "comments#downvote"
      put "unvote", to: "comments#unvote"
    end
  end
  resources :users
  resources :submissions do
    member do
      put "like", to: "submissions#upvote"
      put "dislike", to: "submissions#downvote"
      put "unvote", to: "submissions#unvote"
    end
    resources :comments
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'submissions#index', type: :points

  get 'news' => 'submissions#index', as: :news_menu, type: :points
  get 'newest' => 'submissions#index', as: :newest_menu, type: :created_at
  get 'ask' => 'submissions#index', as: :ask_menu, type: :ask
  get 'my_comments' => 'comments#my_comments', as: :my_comments
  get 'my_submissions' => 'submissions#my_submissions', as: :my_submissions
  get 'my_voted_comments' => 'comments#my_voted_comments', as: :my_voted_comments
  get 'my_voted_submissions' => 'submissions#my_voted_submissions', as: :my_voted_submissions

  get 'auth/:provider/callback', to: 'sessions#create', as: :auth
  get 'auth/failure', to: redirect('/')
  get 'users/:uid' => 'users#index'
  get 'logout', to: 'sessions#destroy', as: :logout

end
