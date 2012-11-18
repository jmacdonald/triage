require 'spec_helper'
include Warden::Test::Helpers

describe 'root route' do
  context 'when the current user is an administrator' do
    before(:each) do
      @user = FactoryGirl.create :user, role: 'administrator'
      login_as @user, scope: 'user'
    end

    it 'should route root to unassigned requests' do 
      get '/'
      path.should eq('/')
      request.params[:controller].should eq('requests')
      request.params[:action].should eq('unassigned')
    end
  end

  context 'when the current user is a provider' do
    before(:each) do
      @user = FactoryGirl.create :user, role: 'provider'
      login_as @user, scope: 'user'
    end

    it 'should route root to open assignments' do 
      get '/'
      path.should eq('/')
      request.params[:controller].should eq('requests')
      request.params[:action].should eq('open_assignments')
    end
  end

  context 'when the current user is requester' do
    before(:each) do
      @user = FactoryGirl.create :user, role: 'requester'
      login_as @user, scope: 'user'
    end

    it 'should route root to open requests' do 
      get '/'
      path.should eq('/')
      request.params[:controller].should eq('requests')
      request.params[:action].should eq('open')
    end
  end

  context 'when there is no user' do
    it 'should redirect to sign in' do 
      get '/'
      response.redirect?.should be_true
    end
  end
end
