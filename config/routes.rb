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
  root 'submissions#index'

  get 'news' => 'submissions#index', as: :news_menu
  get 'newest' => 'submissions#index', as: :newest_menu, sort_by: :created_at
  get 'ask' => 'submissions#index', as: :ask_menu, type: :ask

  get 'auth/:provider/callback', to: 'sessions#create', as: :auth
  get 'auth/failure', to: redirect('/')
  get 'users/:uid' => 'users#index'
  get 'logout', to: 'sessions#destroy', as: :logout

  get '/api-editor', :to => redirect('/swagger-editor/index.html?url=/api-docs.yaml'), as: :swagger_editor
  get '/api-ui', :to => redirect('/swagger-ui/dist/index.html?url=/api-docs.yaml'), as: :swagger_ui

  # custom error pages (not stack trace)
  get "/404" => "errors#not_found"
  get "/500" => "errors#exception"
end
