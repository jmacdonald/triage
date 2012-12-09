Triage::Application.routes.draw do
  require File.expand_path("../../lib/custom_constraints", __FILE__)
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
    get 'search', :on => :collection
    resources :comments, :only => [:create]
    resources :attachments, :only => [:create, :destroy]
  end

  scope 'settings' do
    get 'profile' => 'settings#edit_profile', as: 'edit_profile'
    put 'profile' => 'settings#update_profile', as: 'update_profile'
    get 'password' => 'settings#edit_password', as: 'edit_password'
  end
  
  mount Notifier::Preview => 'mail_view' if Rails.env.development?

  root :to => 'requests#unassigned', :constraints => RoleConstraint.new('administrator')
  root :to => 'requests#open_assignments', :constraints => RoleConstraint.new('provider')
  root :to => 'requests#open'
end
