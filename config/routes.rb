TodoPropa::Application.routes.draw do

  devise_for :users

  resources :appunti do
    collection do
      put :update_attribute_on_the_spot
    end
  end
  
  resources :scuole do
    collection do
      put :update_attribute_on_the_spot
    end
  end

  root :to => 'appunti#index'

end
