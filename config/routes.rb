Rails.application.routes.draw do
  match "auth/:provider/callback", to: "sessions#create", via: %i[get post]
  get "auth/sign_out", to: "sessions#sign_out", as: :sign_out

  get "library.csv", to: "root#library_csv"

  resources :sessions, only: :new

  # The 'new' and 'create' routes are nested under /books, so are excluded here
  resources :copy, only: %i[show edit update], controller: "copies" do
    collection do
      post :lookup
    end

    member do
      post :borrow
      post :return

      put :missing, to: "copies#set_missing"
      delete :missing, to: "copies#unset_missing"
    end
  end

  resources :books, except: :destroy do
    member do
      get :history
    end

    resources :copies, only: %i[new create]
  end

  resources :user, only: :show

  root to: "root#start"
end
