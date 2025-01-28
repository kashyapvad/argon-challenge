Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Route to display the search form
  get 'clinical_trials/search', to: 'clinical_trials#search_form', as: 'search_clinical_trials'

  # Route to handle the search submission
  post 'clinical_trials/search', to: 'clinical_trials#search', as: 'perform_search_clinical_trials'

  # Optional: Root path to the search form
  root 'clinical_trials#search_form'

  # Defines the root path route ("/")
  # root "posts#index"
end
