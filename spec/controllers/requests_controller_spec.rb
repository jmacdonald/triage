require 'spec_helper'

describe RequestsController do
  before(:each) do
    @current_user = FactoryGirl.create :user, role: 'administrator'
    sign_in @current_user

    @target_request = FactoryGirl.create :request, requester: @current_user
  end

  describe 'new action' do
    before(:each) do
      get :new
    end
    
    it 'should work' do
      response.should be_success
    end

    it 'should instantiate a new in-memory request' do
      assigns(:request).should_not be_nil
    end

    it 'should instantiate using the current user as the requester' do
      assigns(:request).requester.id.should eq(@current_user.id)
    end
  end

  describe 'create action' do
    before(:each) do
      # Create a system and status for the new request.
      system = FactoryGirl.create :system
      status = FactoryGirl.create :status

      # Create attributes for the new request, associating the new system and status.
      request_attributes = FactoryGirl.attributes_for :request
      request_attributes[:system_id] = system.id
      request_attributes[:status_id] = status.id

      post :create, { :request => request_attributes }
    end

    it 'should work' do
      response.should be_redirect
    end

    it 'should redirect to the request\'s show action' do
      response.should redirect_to(:action => :show, :id => assigns(:request))
    end

    it 'should instantiate a request object' do
      assigns(:request).should_not be_nil
    end

    it 'should set the current user as the requester by default' do
      assigns(:request).requester.should eq(@current_user)
    end

    it 'should render the "new" action template when there is an error' do
      # Submit an empty request.
      post :create
      
      response.should render_template('new')
    end
  end

  describe 'index action' do
    before(:each) do
      get :index
    end

    it 'should work' do
      response.should be_success
    end

    it 'should show all requests' do
      assigns(:requests).count.should eq(Request.count)
    end

    it 'should paginate results' do
      assigns(:requests).to_sql.should include "LIMIT #{Kaminari.config.default_per_page}"
    end
  end

  describe 'open action' do
    before(:each) do
      get :open
    end

    it 'should work' do
      response.should be_success
    end

    it 'should only return requests owned by the current user' do
      assigns(:requests).each do |request|
        request.requester.should eq(@current_user)
      end
    end

    it 'should only return open requests' do
      assigns(:requests).each do |request|
        request.status.closed?.should be_false
      end
    end

    it 'should paginate results' do
      assigns(:requests).to_sql.should include "LIMIT #{Kaminari.config.default_per_page}"
    end
  end

  describe 'closed action' do
    before(:each) do
      get :closed
    end

    it 'should work' do
      response.should be_success
    end

    it 'should only return requests owned by the current user' do
      assigns(:requests).each do |request|
        request.requester.should eq(@current_user)
      end
    end

    it 'should only return closed requests' do
      assigns(:requests).each do |request|
        request.status.closed?.should be_true
      end
    end

    it 'should paginate results' do
      assigns(:requests).to_sql.should include "LIMIT #{Kaminari.config.default_per_page}"
    end
  end

  describe 'unassigned action' do
    before(:each) do
      get :unassigned
    end

    it 'should work' do
      response.should be_success
    end

    it 'should only return unassigned requests' do
      assigns(:requests).each do |request|
        request.assignee.should be_nil
      end
    end

    it 'should paginate results' do
      assigns(:requests).to_sql.should include "LIMIT #{Kaminari.config.default_per_page}"
    end
  end

  describe 'open assignments action' do
    before(:each) do
      get :open_assignments
    end

    it 'should work' do
      response.should be_success
    end

    it 'should only show requests assigned to the current user' do
      assigns(:requests).each do |request|
        request.assignee.should eq(@current_user)
      end
    end

    it 'should only return open assignments' do
      assigns(:requests).each do |request|
        request.status.closed?.should be_false
      end
    end

    it 'should paginate results' do
      assigns(:requests).to_sql.should include "LIMIT #{Kaminari.config.default_per_page}"
    end
  end

  describe 'closed assignments action' do
    before(:each) do
      get :closed_assignments
    end

    it 'should work' do
      response.should be_success
    end

    it 'should only show requests assigned to the current user' do
      assigns(:requests).each do |request|
        request.assignee.should eq(@current_user)
      end
    end

    it 'should only return closed assignments' do
      assigns(:requests).each do |request|
        request.status.closed?.should be_true
      end
    end

    it 'should paginate results' do
      assigns(:requests).to_sql.should include "LIMIT #{Kaminari.config.default_per_page}"
    end
  end

  describe 'show action' do
    context 'when the current user is the requester' do
      before(:each) do
        get :show, :id => @target_request.id
      end

      it 'should work' do
        response.should be_success
      end
    end

    context 'when the current user is not the requester' do
      before :each do
        @foreign_request = FactoryGirl.create :request
        get :show, :id => @foreign_request.id
      end

      it 'should work' do
        response.should be_success
      end
    end
  end

  describe 'update action' do
    before(:each) do
      put :update, {
        id: @target_request.id,
        request: {
         title: 'New Title'
        }
      } 
    end

    it 'should work' do
      response.should be_redirect
    end

    it 'should update the specified attribute' do
      assigns(:request).title.should eq('New Title')
    end

    it 'should only update the attributes provided' do
      assigns(:request).description.should eq(@target_request.description)
    end

    it 'should redirect to the request\'s show action' do
      response.should redirect_to(:action => :show, :id => @target_request.id)
    end
  end

  describe 'delete action' do
    before(:each) do
      delete :destroy, id: @target_request.id
    end

    it 'should work' do
      response.should be_redirect
    end

    it 'should redirect to the request index action' do
      response.should redirect_to(:action => :index)
    end
  end

  describe 'search action' do
    context 'with an exact id' do
      before(:each) do
        get :search, {
          request_id: @target_request.id
        }
      end

      it 'should work' do
        response.should be_redirect
      end

      it 'should redirect to the request show action' do
        response.should redirect_to(:action => :show, :id => @target_request.id)
      end
    end

    context 'without an id' do
      before(:each) do
        get :search
      end

      it 'should work' do
        response.should be_success
      end

      it 'should show the search listing page' do
        response.should render_template('search')
      end

      it 'should have an empty array of results' do
        assigns(:requests).should eq([])
      end
    end

    context 'with an invalid id' do
      before(:each) do
        get :search, {
          request_id: 'asdf098'
        }
      end

      it 'should work' do
        response.should be_success
      end

      it 'should show the search listing page' do
        response.should render_template('search')
      end

      it 'should have an empty array of results' do
        assigns(:requests).should eq([])
      end
    end
  end
end
