Rails.application.routes.draw do
  resources :news
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'news#index'
  get 'newest' => 'newest#index'
end
