Rails.application.routes.draw do
  resources :submissions
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'submissions#index'

  get 'news' => 'submissions#index', as: :news_menu, type: :points
  get 'newest' => 'submissions#index', as: :newest_menu, type: :created_at
  get 'ask' => 'submissions#index', as: :ask_menu, type: :ask
end
