Rails.application.routes.draw do
  get 'welcome/index'
  root 'welcome#index'


  devise_for :users, :skip => [:registrations], controllers: {
    sessions: 'devise/sessions'
  }
    
  ActiveAdmin.routes(self)

  #mount ApplicationApi, at: "/"

  mount API, at:  "/"

  # devise_scope :user do
  #   get "/login", :to => "devise/sessions#new" # Add a custom sign in route for user sign in
  #   get "/logout", :to =>  "devise/sessions#destroy" # Add a custom sing out route for user sign out
  #   #get "/register", :to "devise/registrations#new" # Add a Custom Route for Registrations
  #   #root :to  => "devise/sessions#new"
  # end

  # devise_scope :user do
  #   authenticated  do
  #     root to: 'admin/dashboard#index'
  #   end

  #   unauthenticated do
  #     root to: 'devise/sessions#new', as: 'unauthenticated_root'
  #   end
  # end  



  #root_to devise/sessions#new
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
