Rails.application.routes.draw do
  
 

  resources :interventions do 
    collection do
      get :get_buildings
      get :get_batteries
      get :get_columns
      get :get_elevators
    end
  end

  devise_for :users, :controllers => { :registrations => "users/registrations"}
  devise_for :employees, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  resources :pages
  resources :quote
  resources :leads

  # root to: 'geolocalisation#index'
  root 'leads#new'

  get 'index' => 'leads#new' # index
  get 'corporate' => 'pages#corporate' # corporate
  get 'residential' => 'pages#residential' # residential
  get 'quoteform' => 'quote#new' # quote form
  get 'login' => 'pages#login'
  get 'sign_up' => 'users#sign_up'
  get 'sign_in' => 'users#sign_in'
  get 'leads' => 'leads#new'
  get 'interv' => 'interventions#new'


  get 'welcome' => 'watson#welcome'
  get 'geolocalisation/index'

  get 'dropbox/auth' => 'dropbox#auth'
  get 'dropbox/auth_callback' => 'dropbox#auth_callback'
  # namespace :admin do
  #   resources :addresses do
  #     resources :customers do
  #       resources :buildings do
  #         resources :building_details
  #       end
  #     end
  #   end
  # end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
