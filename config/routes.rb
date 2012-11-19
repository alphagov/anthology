Books::Application.routes.draw do
  match "auth/:provider/callback" => "sessions#create"
  get "auth/sign_out" => "sessions#sign_out", :as => :sign_out

  resources :sessions, :only => :new do
    get :failure, :collection => true
  end

  resources :books do
    resources :copies do
      member do
        post :borrow
        post :return
      end
    end
  end

  root :to => "books#index"
end
