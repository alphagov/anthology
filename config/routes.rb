Books::Application.routes.draw do
  match "auth/:provider/callback" => "sessions#create"
  get "auth/sign_out" => "sessions#sign_out", :as => :sign_out

  resources :sessions, :only => :new do
    get :failure, :collection => true
  end

  post '/copy' => 'copy#find', :as => :find_copy
  get '/copy/:id' => 'copy#show', :as => :copy

  get '/books/isbn/:isbn' => "books#lookup_isbn", :as => :book_isbn_lookup
  get '/books/list' => "books#index", :as => :book_list, :display => 'list'
  resources :books do
    member do
      get :history
    end

    resources :copies do
      member do
        post :borrow
        post :return
      end
    end
  end

  resources :user, :only => :show

  root :to => "root#start"
end
