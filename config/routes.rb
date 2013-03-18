ServerWatcher::Application.routes.draw do
  devise_for :accounts

  root to: 'welcome#index'

  get '/contact', to: 'welcome#contact'

  resources :servers do
    resources :ping_logs, only: [:index, :show, :destroy]
    resources :httping_logs, only: [:index, :show, :destroy]
  end
end
