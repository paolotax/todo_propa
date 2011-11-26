TodoPropa::Application.routes.draw do

  devise_for :users

  resources :appunti
  resources :scuole

  root :to => 'scuole#index'

end
