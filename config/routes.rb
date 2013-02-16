SocialMonitor::Application.routes.draw do
  get "pay_pal/return"

  get "pay_pal/cancel"

  get "pay_pal/create"

  resources :statistics
  resources :pages
  resources :websites
  devise_for :users
  
  get 'websites/reindex/:id' => 'websites#reindex'
  get 'account' => 'static#account'
  get 'upgrade' => 'static#upgrade'
  get 'confirm_upgrade' => 'static#confirm_upgrade'
  get 'p/:id' => 'static#public'
  get 'help' => 'static#help'
  get 'contact' => 'static#contact'
  
  root :to => 'static#index'
end
