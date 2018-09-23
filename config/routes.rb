Rails.application.routes.draw do
  resources :companies
  resources :indices
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #define namespace for the customers api
  # the company does not need to be an api as  a company will be greated by MoneyLoop when a services agreement is signed.

  namespace 'api' do
    namespace 'v1' do
      resources :customers
      resources :claims
      get "/customers", to: 'customers#index'
      get "/customers(.:format)", to: 'customers#index'
      post "/customers(.:format)", to: 'customers#create'
      get "/customers/new(.:format)",to: 'customers#new'
      get "/customers/:id/edit(.:format)", to: 'customers#edit'
      get "/customers/:id(.:format)", to: 'customers#show'
      patch "/customers/:id(.:format)", to: 'customers#update'
      put "/customers/:id(.:format)", to: 'customers#update'
      delete "/customers/:id(.:format)", to: 'customers#destroy'
    end
  end
  get "/indices/claim/:id(.:format)", to: "indices#create_claim"

  root "indices#index"
end
