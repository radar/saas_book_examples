require "subscribem/constraints/subdomain_required"

Subscribem::Engine.routes.draw do
  constraints(Subscribem::Constraints::SubdomainRequired) do
    scope :module => "account" do
      root :to => "dashboard#index", :as => :account_root
      get "/sign_in", :to => "sessions#new", :as => :sign_in
      post "/sign_in", :to => "sessions#create", :as => :sessions
    end
  end

  root "dashboard#index"
  get "/sign_up", :to => "accounts#new", :as => :sign_up
  post "/accounts", :to => "accounts#create", :as => :accounts

end