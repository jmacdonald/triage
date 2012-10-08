require 'test_helper'

class RequestsControllerTest < ActionController::TestCase
  setup do
    sign_in users :valid
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
      assert_equal users(:valid), assigns(:request).requester
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
      assert_equal users(:valid), assigns(:request).requester
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

    should 'not show assignments' do
      assert_equal users(:valid), assigns(:requests).first.requester
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

  context 'edit action' do
    setup do
      get :edit, :id => requests(:valid).id
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
