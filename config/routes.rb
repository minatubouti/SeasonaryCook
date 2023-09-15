Rails.application.routes.draw do

    # 管理者側
    devise_for :admin, skip: %i[registrations passwords] ,controllers: {
    sessions: "admin/sessions"
   }
  namespace :admin do
    get '/' => 'homes#top'
    resources :users, only: %i[index show edit update destroy]
    resources :posts, only: %i[index show edit update destroy]
    resources :comments, only: %i[index destroy]
    resources :inquiries, only: %i[index show update] 
  end
  
  
# ユーザ側ルーティング
    devise_for :users,skip: [:passwords], controllers: {
      registrations: 'public/registrations',
      sessions: 'public/sessions'
    }
 
  scope module: :public do
    root :to => "homes#top"
    get '/about' => 'homes#about'
    resources :users, only: %i[show edit update] do
    resource :relationships, only:%i[create destroy]
      get 'follows' => 'relationships#follower'
      get 'followers' => 'relationships#followed'
      get 'bookmarks', on: :member
    member do
      get 'likes'
    end
    member do
      get :check_out
      patch :withdraw
    end
  end
  resources :posts do
    resources :comments, only: [:create]
    resources :likes, only: %i[create destroy]
    resources :bookmarks, only: %i[create destroy]
  end
    resources :notifications, only: [:index]
    resources :inquiries, only: %i[new create show]
    resources :tags, only: %i[index show]
  end
  
  devise_scope :user do
    post 'users/guest_sign_in', to: 'public/sessions#guest_sign_in'
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
