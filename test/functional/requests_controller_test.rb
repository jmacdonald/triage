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
      }}
    end

    should 'work' do
      assert_redirected_to requests_url
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

    should 'not show requests from another user' do
      assert_equal 1, assigns(:requests).count
    end

    should 'not show assignments' do
      assert_equal users(:valid), assigns(:requests).first.requester
    end
  end

  context 'show action' do
    setup do
      get :show, :id => users(:valid).id
    end

    should 'work' do
      assert_response :success
    end

    should 'not show requests from another user' do
      assert_raise ActiveRecord::RecordNotFound do
        get :show, :id => users(:mia).id
      end
    end
  end

  context 'edit action' do
    setup do
      get :edit, :id => users(:valid).id
    end

    should 'work' do
      assert_response :success
    end

    should 'not allow edits to requests from another user' do
      assert_raise ActiveRecord::RecordNotFound do
        get :edit, :id => users(:mia).id
      end
    end
  end

  context 'update action' do
    setup do
      put :update, {
        id: users(:valid).id,
        request: {
         title: 'New Title'
        }
      } 
    end

    should 'work' do
      assert_response :redirect
    end

    should 'redirect to the request\'s show action' do
      assert_redirected_to :action => :show
    end

    should 'not allow updates to requests from another user' do
      assert_raise ActiveRecord::RecordNotFound do
        put :update, :id => users(:mia).id
      end
    end
  end
end
