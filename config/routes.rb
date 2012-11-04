Triage::Application.routes.draw do
  devise_for :users
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  # Assignment routes. These are really just requests, but with some filters.
  scope 'assignments' do
    get 'open' => 'requests#open_assignments', :as => 'open_assignments'
    get 'closed' => 'requests#closed_assignments', :as => 'closed_assignments'
  end

  resources :requests do
    get 'open', :on => :collection
    get 'closed', :on => :collection
    get 'unassigned', :on => :collection
    resources :comments, :only => [:create]
    resources :attachments, :only => [:create, :destroy]
  end

  if Rails.env.development?
    mount Notifier::Preview => 'mail_view'
  end

  root :to => 'requests#index'
end
