Rails.application.routes.draw do
  resources :submissions
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'submissions#index'

  get 'news' => 'submissions#index', as: :news_menu
  get 'newest' => 'newest#index'
  get 'ask' => 'submissions#ask'
end
