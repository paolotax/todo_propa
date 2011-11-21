TodoPropa::Application.routes.draw do

  resources :appunti
  resources :scuole

  root :to => 'scuole#index'

end
