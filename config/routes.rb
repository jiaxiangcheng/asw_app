Rails.application.routes.draw do
  resources :comments do
    member do
      put "like", to: "comments#upvote"
      put "dislike", to: "comments#downvote"
      put "unvote", to: "comments#unvote"
      post "reply", to: "comments#createreply"
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
  get 'voted_comments' => 'comments#voted_comments', as: :voted_comments
  get 'voted_submissions' => 'submissions#voted_submissions', as: :voted_submissions

  get 'auth/:provider/callback', to: 'sessions#create', as: :auth
  get 'auth/failure', to: redirect('/')
  get 'users/:uid' => 'users#index'
  get 'logout', to: 'sessions#destroy', as: :logout
  get '/submissions/:submission_id/comments/:id/showreply', to: 'comments#showreply'

  get '/api', :to => redirect('/swagger-editor/index.html?url=/api-docs.yaml'), as: :swagger_editor


  #API ROUTES 
  post 'submissions' => 'submissions#create'
  post 'submissions/ask' => 'submissions#apiCreateAsk'
  post 'submissions/url' => 'submissions#apiCreateUrl'

end
