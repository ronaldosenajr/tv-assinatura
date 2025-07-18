Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  root "clients#index"

  resources :clients

  resources :plans, only: [ :index, :show, :create, :update, :destroy ]

  resources :additional_services, only: [ :index, :show, :create, :update, :destroy ]

  resources :packages, only: [ :index, :show, :create, :update, :destroy ]

  resources :subscriptions, only: [ :index, :show, :create, :update, :destroy ] do
    # rota para faturamento, totais, etc
    get "billing_totals", on: :member
    get :booklet, on: :member
    get :booklet_pdf, on: :member
    post :cancel_subscription, on: :member
  end
end
