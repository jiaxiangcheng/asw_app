Rails.application.routes.draw do
  resources :submissions
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'submissions#index'

  get 'news' => 'submissions#index', as: :news_menu, order: :points
  get 'newest' => 'submissions#index', as: :newest_menu, order: :created_at
  get 'ask' => 'submissions#ask'
end
