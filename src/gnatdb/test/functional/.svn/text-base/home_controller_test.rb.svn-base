require 'test_helper'
include AuthenticatedTestHelper

class HomeControllerTest < ActionController::TestCase
  fixtures :users

  def test_index
    get :index
    assert_response :success
  end
  
  def test_login
    get :index
    assert_response :success
    # ensure login form is provided
    # assert_post_form '/session'
  end
  
  def test_logged_in
    login_as (:fred)
    get :index
    assert_response :success
    # ensure login form is not provided
    # assert_links_to '/logout', 'Logout'    
  end

end
