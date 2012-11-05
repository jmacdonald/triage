require 'test_helper'

class RoutesTest < ActionController::IntegrationTest
  # Devise Routes
  should 'route new user session' do
    assert_routing({ :path => '/users/sign_in', :method => :get }, { :controller => 'devise/sessions', :action => 'new' })
  end

  should 'route user session' do 
    assert_routing({ :path => '/users/sign_in', :method => :post }, { :controller => 'devise/sessions', :action => 'create' })
  end

  should 'route destroy user session' do
    assert_routing({ :path => '/users/sign_out', :method => :delete }, { :controller => 'devise/sessions', :action => 'destroy' })
  end

  should 'route user password' do
    assert_routing({ :path => '/users/password', :method => :post }, { :controller => 'devise/passwords', :action => 'create' })
  end

  should 'route new user password' do
    assert_routing({ :path => '/users/password/new', :method => :get }, { :controller => 'devise/passwords', :action => 'new' })
  end

  should 'route edit user password' do
    assert_routing({ :path => '/users/password/edit', :method => :get }, { :controller => 'devise/passwords', :action => 'edit' })
  end

  should 'route update user password' do
    assert_routing({ :path => '/users/password', :method => :put }, { :controller => 'devise/passwords', :action => 'update' })
  end

  should 'route cancel user registration' do
    assert_routing({ :path => '/users/cancel', :method => :get }, { :controller => 'devise/registrations', :action => 'cancel' })
  end

  should 'route create user registration' do
    assert_routing({ :path => '/users/sign_up', :method => :get }, { :controller => 'devise/registrations', :action => 'new' })
  end

  should 'route new user registration' do
    assert_routing({ :path => '/users', :method => :post }, { :controller => 'devise/registrations', :action => 'create' })
  end

  should 'route edit user registration' do
    assert_routing({ :path => '/users/edit', :method => :get }, { :controller => 'devise/registrations', :action => 'edit' })
  end

  should 'route update user registration' do
    assert_routing({ :path => '/users', :method => :put }, { :controller => 'devise/registrations', :action => 'update' })
  end

  should 'route destroy user registration' do
    assert_routing({ :path => '/users', :method => :delete }, { :controller => 'devise/registrations', :action => 'destroy' })
  end

  # Assignment Routes
  should 'route open assignments' do
    assert_routing({ :path => '/assignments/open', :method => :get }, { :controller => 'requests', :action => 'open_assignments' })
  end

  should 'route closed assignments' do
    assert_routing({ :path => '/assignments/closed', :method => :get }, { :controller => 'requests', :action => 'closed_assignments' })
  end

  # Request Routes
  should 'route request index' do
    assert_routing({ :path => '/requests', :method => :get }, { :controller => 'requests', :action => 'index' } )
  end

  should 'route new request' do
    assert_routing({ :path => '/requests/new', :method => :get }, { :controller => 'requests', :action => 'new' } )
  end  

  should 'route create request' do
    assert_routing({ :path => '/requests', :method => :post }, { :controller => 'requests', :action => 'create' } )
  end  

  should 'route show request' do
    assert_routing({ :path => '/requests/1', :method => :get }, { :controller => 'requests', :action => 'show', :id => '1' } )
  end

  should 'route edit request' do
    assert_routing({ :path => '/requests/1/edit', :method => :get }, { :controller => 'requests', :action => 'edit', :id => '1' } )
  end

  should 'route update request' do
    assert_routing({ :path => '/requests/1', :method => :put }, { :controller => 'requests', :action => 'update', :id => '1' } )
  end

  should 'route destroy request' do
    assert_routing({ :path => '/requests/1', :method => :delete }, { :controller => 'requests', :action => 'destroy', :id => '1' } )
  end

  should 'route open requests' do
    assert_routing({ :path => '/requests/open', :method => :get }, { :controller => 'requests', :action => 'open' } )
  end

  should 'route closed requests' do
    assert_routing({ :path => '/requests/closed', :method => :get }, { :controller => 'requests', :action => 'closed' } )
  end

  should 'route unassigned requests' do
    assert_routing({ :path => '/requests/unassigned', :method => :get }, { :controller => 'requests', :action => 'unassigned' } )
  end

  should 'route create request comment' do
    assert_routing({ :path => '/requests/1/comments', :method => :post }, { :controller => 'comments', :action => 'create', :request_id => '1' } )
  end

  should 'route create request attachment' do
    assert_routing({ :path => '/requests/1/attachments', :method => :post }, { :controller => 'attachments', :action => 'create', :request_id => '1' } )  
  end  

  should 'route destroy request attachment' do
    assert_routing({ :path => '/requests/1/attachments/1', :method => :delete }, { :controller => 'attachments', :action => 'destroy', :request_id => '1', :id => '1' } )  
  end 

  # Letter Opener Route
  context 'in development environment' do
    setup { ENV['RACK_ENV'] = 'development' }
    should 'route letter opener mail view' do
      pending 'not sure how to test, as it is not an engine'
    end
  end

  # Root Routes
  context 'when the current user is an administrator' do
    should 'route root to unassigned requests' do 
      pending 'need to figure out how to setup user, request object is nil, so devise helpers dont work'
      # assert_routing({ :path => '/', :method => :get }, { :controller => 'requests', :action => 'unassigned' } )
    end
  end

  context 'when the current user is a provider' do
    should 'route root to open assignments' do
      pending 'need to figure out how to setup user, request object is nil, so devise helpers dont work'
      # assert_routing({ :path => '/', :method => :get }, { :controller => 'requests', :action => 'open_assignments' } )
    end
  end

  should 'route root to open requests' do
    pending 'need to figure out how to setup user, request object is nil, so devise helpers dont work'
    # assert_routing({ :path => '/', :method => :get }, { :controller => 'requests', :action => 'open' } )
  end

end