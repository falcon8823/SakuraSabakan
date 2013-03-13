ServerWatcher::Application.routes.draw do
  root to: 'welcome#index'

  resources :servers do
    resources :ping_logs, only: [:index, :show, :destroy]
    resources :httping_logs, only: [:index, :show, :destroy]
  end
end
