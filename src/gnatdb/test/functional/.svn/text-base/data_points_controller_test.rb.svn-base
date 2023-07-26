require 'test_helper'
include AuthenticatedTestHelper


class DataPointsControllerTest < ActionController::TestCase
  fixtures :users, :data_points
    
  # logged in 
  # %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  def test_should_get_index    
    login_as (:fred)
    get :index
    assert_response :success
    # expected
    assert_not_nil assigns(:data_today)
    assert_not_nil assigns(:data_yesterday)
    # not expected
    assert_nil assigns(:data)
  end
  
  # alternate index (all with pagination)
  def test_should_get_index_all
    login_as (:fred)
    get :index, {'view' => 'all'}
    assert_response :success
    # expected
    assert_not_nil assigns(:data)
    # not expected
    assert_nil assigns(:data_today)
    assert_nil assigns(:data_yesterday)
  end

  def test_should_get_new
    login_as (:fred)
    get :new
    assert_response :success
  end

  def test_should_create_data_point
    login_as (:fred)
    assert_difference('DataPoint.count') do
      post :create, :data_point => {:date=>(Date.today-10), :datum=>"10 blurg, t1, t2"}
    end
    # redireced to same page
    assert_redirected_to new_data_point_path
    # ensure record was created
    point = DataPoint.find_by_label("blurg")
    assert_not_nil point
    assert_equal 10, point.data
    assert_equal (Date.today-10), point.date
    assert_equal 2, point.tag_list.size    
    assert_equal users(:fred), point.user
  end
  
  def test_should_create_data_point_advanced
    login_as (:fred)
    assert_difference('DataPoint.count') do
      post :create, {:data_point => {:data=>10, :label=>'blurg', :date=>(Date.today-10), :tag_list=>"t1, t2"}, 'advanced'=>'true' }
    end
    # redireced to same page
    assert_redirected_to new_data_point_path(:advanced=>"true")
    # ensure record was created
    point = DataPoint.find_by_label("blurg")
    assert_not_nil point
    assert_equal 10, point.data
    assert_equal (Date.today-10), point.date
    assert_equal 2, point.tag_list.size
    assert_equal users(:fred), point.user
  end

  def test_should_show_data_point
    login_as (:fred)
    get :show, :id => data_points(:pushup).id
    assert_response :success
  end

  def test_should_get_edit
    login_as (:fred)
    get :edit, :id => data_points(:pushup).id
    assert_response :success
  end

  def test_should_update_data_point
    login_as (:fred)
    put :update, :id => data_points(:pushup).id, :data_point => {:data=>10, :label=>'blurg', :date=>(Date.today-10), :tag_list=>"t1, t2, t2" }
    assert_redirected_to data_point_path(assigns(:data_point))
    # ensure the data is changed
    point = DataPoint.find_by_label("blurg")
    assert_not_nil point
    assert_equal 10, point.data
    assert_equal (Date.today-10), point.date
    assert_equal 2, point.tag_list.size
    assert_equal users(:fred), point.user
  end

  def test_should_destroy_data_point
    login_as (:fred)
    assert_difference('DataPoint.count', -1) do
      delete :destroy, :id => data_points(:pushup).id
    end

    assert_redirected_to data_points_path
  end
  
  
  # not logged in 
  # %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  def test_should_not_get_index_when_not_logged_in
    get :index
    assert_redirected_to login_path
  end
  
  # alternate index (all with pagination)
  def test_should_not_get_index_all_when_not_logged_in
    get :index, {'view' => 'all'}
    assert_redirected_to login_path
  end

  def test_should_not_get_new_when_not_logged_in
    get :new
    assert_redirected_to login_path
  end

  def test_should_not_create_data_point_when_not_logged_in
    assert_no_difference('DataPoint.count') do
      post :create, :data_point => {:date=>Date.today, :datum=>"10 blurg, t1, t2"}
    end

    assert_redirected_to login_path
  end
  
  def test_should_not_create_data_point_advanced_when_not_logged_in
    assert_no_difference('DataPoint.count') do
      post :create, {:data_point => {:data=>10, :label=>'blurg', :date=>Date.today}, 'advanced'=>'true' }
    end

    assert_redirected_to login_path
  end

  def test_should_not_show_data_point_when_not_logged_in
    get :show, :id => data_points(:pushup).id
    assert_redirected_to login_path
  end

  def test_should_not_get_edit_when_not_logged_in
    get :edit, :id => data_points(:pushup).id
    assert_redirected_to login_path
  end

  def test_should_not_update_data_point_when_not_logged_in
    put :update, :id => data_points(:pushup).id, :data_point => { }
    assert_redirected_to login_path
  end

  def test_should_not_destroy_data_point_when_not_logged_in
    assert_no_difference('DataPoint.count', -1) do
      delete :destroy, :id => data_points(:pushup).id
    end

   assert_redirected_to login_path
  end
  
end
