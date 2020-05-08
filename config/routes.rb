# typed: false
Rails.application.routes.draw do
  match "auth/:provider/callback" => "sessions#create", via: %i[get post]
  get "auth/sign_out" => "sessions#sign_out", :as => :sign_out

  get "library.csv", to: "root#library_csv"

  resources :sessions, only: :new do
    get :failure, collection: true
  end

  resources :copy, controller: "copies" do
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

  get "/books/isbn/:isbn" => "books#lookup_isbn", :as => :book_isbn_lookup
  get "/books/list" => "books#index", :as => :book_list, :display => "list"
  resources :books do
    member do
      get :history
    end

    resources :copies
  end

  resources :copies, only: %i[edit update]

  resources :user, only: :show

  root to: "root#start"
end
