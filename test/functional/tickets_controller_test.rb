require 'test_helper'

class RequestsControllerTest < ActionController::TestCase
  setup do
    sign_in users :valid
    @current_user = users :valid
  end

  context 'new action' do
    setup do
      get :new
    end
    
    should 'work' do
      assert_response :success
    end

    should 'instantiate a new in-memory request' do
      assert assigns(:request)
    end

    should 'instantiate using the current user as the requester' do
      assert_equal @current_user, assigns(:request).requester
    end
  end

  context 'create action' do
    setup do
      post :create, { :request => {
        title: requests(:valid).title,
        description: requests(:valid).description,
        system_id: requests(:valid).system.id
      }}
    end

    should 'work' do
      assert_response :redirect
    end

    should 'redirect to the request\'s show action' do
      assert_redirected_to :action => :show, :id => assigns(:request)
    end

    should 'instantiate a request object' do
      assert assigns(:request)
    end

    should 'set the current user as the requester by default' do
      assert_equal @current_user, assigns(:request).requester
    end

    should 'render the "new" action template when there is an error' do
      # Submit an empty request.
      post :create
      
      assert_template "new"
    end
  end

  context 'index action' do
    setup do
      get :index
    end

    should 'work' do
      assert_response :success
    end

    should 'show all requests' do
      assert_equal Request.count, assigns(:requests).count
    end
  end

  context 'open action' do
    setup do
      get :open
    end

    should 'work' do
      assert_response :success
    end

    should 'only return requests owned by the current user' do
      assigns(:requests).each do |request|
        assert_equal users(:valid), request.requester
      end
    end

    should 'only return open requests' do
      assigns(:requests).each do |request|
        assert_false request.status.closed?
      end
    end
  end

  context 'closed action' do
    setup do
      get :closed
    end

    should 'work' do
      assert_response :success
    end

    should 'only return requests owned by the current user' do
      assigns(:requests).each do |request|
        assert_equal users(:valid), request.requester
      end
    end

    should 'only return closed requests' do
      assigns(:requests).each do |request|
        assert request.status.closed?
      end
    end
  end

  context 'open assignments action' do
    setup do
      get :open_assignments
    end

    should 'work' do
      assert_response :success
    end

    should 'only show requests assigned to the current user' do
      assigns(:requests).each do |request|
        assert_equal @current_user, request.assignee
      end
    end

    should 'only return open assignments' do
      assigns(:requests).each do |request|
        assert_false request.status.closed?
      end
    end
  end

  context 'closed assignments action' do
    setup do
      get :closed_assignments
    end

    should 'work' do
      assert_response :success
    end

    should 'only show requests assigned to the current user' do
      assigns(:requests).each do |request|
        assert_equal @current_user, request.assignee
      end
    end

    should 'only return closed assignments' do
      assigns(:requests).each do |request|
        assert request.status.closed?
      end
    end
  end

  context 'show action' do
    setup do
      get :show, :id => requests(:valid).id
    end

    should 'work' do
      assert_response :success
    end
  end

  context 'update action' do
    setup do
      put :update, {
        id: requests(:valid).id,
        request: {
         title: 'New Title'
        }
      } 
    end

    should 'work' do
      assert_response :redirect
    end

    should 'update the specified attribute' do
      assert_equal 'New Title', assigns(:request).title
    end

    should 'only update the attributes provided' do
      assert_equal requests(:valid).description, assigns(:request).description
    end

    should 'redirect to the request\'s show action' do
      assert_redirected_to :action => :show, :id => assigns(:request)
    end
  end

  context 'delete action' do
    setup do
      delete :destroy, id: requests(:valid).id
    end

    should 'work' do
      assert_response :redirect
    end

    should 'redirect to the request index action' do
      assert_redirected_to :action => :index
    end
  end
end
