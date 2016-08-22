Rails.application.routes.draw do

  root "projects#index"

  ActiveAdmin.routes(self)
  devise_for :users


  namespace :api do
    get '/c_user' => 'users#c_user'
    resources :projects, only: [:index, :create, :update] do
      put '/access', :to => 'projects#give_access'
      delete '/access', :to => 'projects#deny_access'
      post '/upload_file', :to => 'projects#upload_file'
      delete '/remove_file', :to => 'projects#remove_file'
      resources :tasks, only: [:index, :create, :update] do
        put '/change_status', :to => 'tasks#change_status'
      end
      # resources :users, only: [:index]
    end
  end

  resources :projects, only: [:index]


  resources :user_to_projects



  # resources :comments do
  #   get '_comments', on: :index
  # end
end
