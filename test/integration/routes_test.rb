require 'test_helper'

class RoutesTest < ActionController::IntegrationTest
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
      # pending 'not sure how to test, as it is not an engine'
    end
  end

end