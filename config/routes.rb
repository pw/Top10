Rails.application.routes.draw do
  root "pages#home"
  resources :cities, only: :show do
    post :attractions, on: :member
    post :search, on: :collection
  end  
end
