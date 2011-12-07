TodoPropa::Application.routes.draw do

  devise_for :users

  resources :appunti do
    collection do
      put :update_attribute_on_the_spot
    end
    member do
      get :get_note
    end
  end
  
  resources :scuole do
    collection do
      put :update_attribute_on_the_spot
    end
  end
  
  resources :righe
  
  resources :libri
  
  root :to => 'appunti#index'

end
