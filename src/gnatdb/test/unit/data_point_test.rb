require 'test_helper'

class DataPointTest < ActiveSupport::TestCase
  
  fixtures :users, :data_points
  
  # fixture expectations
  # %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
  
  def test_users_count
    assert_equal 2, User.count
  end
  
  def test_data_points_count
    assert_equal 3, DataPoint.count
  end
  
  
  
  # crud
  # %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  def test_create
    point = users(:fred).data_points.build
    point.date = Date.today
    point.data = 20
    point.label = "blurg"
    point.tag_list = "t1, t2, t3"
    # valid
    assert point.valid?
    # save
    assert point.save
    # retrieve
    point = users(:fred).data_points.find_by_label("blurg")
    assert_equal 20, point.data
    assert_equal 3, point.tag_list.size
    assert_equal Date.today, point.date
    assert_equal users(:fred), point.user
  end
  
  def test_retrieve    
    point = DataPoint.find_by_label("pushup")
    assert_not_nil point
    assert_not_nil point.label
    assert_not_nil point.data
    assert_not_nil point.date
    assert_not_nil point.user
    assert_equal "pushup", point.label
    
    point = DataPoint.find_by_label("situp")
    assert_not_nil point
    assert_not_nil point.label
    assert_not_nil point.data
    assert_not_nil point.date
    assert_not_nil point.user
    assert_equal "situp", point.label
    
    point = DataPoint.find_by_label("run")
    assert_not_nil point
    assert_not_nil point.label
    assert_not_nil point.data
    assert_not_nil point.date
    assert_not_nil point.user
    assert_equal "run", point.label
  end
  
  def test_update
    point = data_points(:pushup)    
    # data
    point.data = 123.123
    assert point.save
    point.reload
    assert 123.123, point.data
    # label
    point.label = "blurg"
    assert point.save
    point.reload
    assert "blurg", point.label
    # date
    point.date = Date.today - 15
    assert point.save
    point.reload
    assert Date.today - 15, point.date
    # tags
    point.tag_list = "t1, t2, t3, t4"
    assert point.save
    point.reload
    assert 4, point.tag_list.size
    point.tag_list = "t1, t3, t4"
    assert point.save
    point.reload
    assert 3, point.tag_list.size
  end
  
  
  def test_destroy
    point = DataPoint.find_by_label("pushup")
    assert_not_nil point
    assert point.destroy
    point = DataPoint.find_by_label("pushup")
    assert_nil point
  end
  

  # data
  # %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  

  def test_data_nil
    data_points(:pushup).data = nil
    assert !data_points(:pushup).valid?
  end
  
  def test_data_blank
    data_points(:pushup).data = ""
    assert !data_points(:pushup).valid?
  end
  
  def test_data_integer
    data_points(:pushup).data = "18"
    assert data_points(:pushup).valid?
  end
  
  def test_data_float
    data_points(:pushup).data = "90.7"
    assert data_points(:pushup).valid?
  end
  
  def test_data_positive
    data_points(:pushup).data = "+10"
    assert data_points(:pushup).valid?
  end
  
  def test_data_negative
    data_points(:pushup).data = "-50000"
    assert data_points(:pushup).valid?
  end
  
  def test_data_float_positive
    data_points(:pushup).data = "+.082739487"
    assert data_points(:pushup).valid?
  end
  
  def test_data_float_negative
    data_points(:pushup).data = "+23.00000002"
    assert data_points(:pushup).valid?
  end
  
  # label
  # %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  def test_label_nil
    data_points(:pushup).label = nil
    assert !data_points(:pushup).valid?
  end
  
  def test_label_blank
    data_points(:pushup).label = ""
    assert !data_points(:pushup).valid?
  end
  
  def test_label_too_long
    # 256 chars
    test_s = "1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456"
    assert (test_s.size == 256) 
    # limit is 255
    data_points(:pushup).label = test_s
    assert !data_points(:pushup).valid?
  end
  
  def test_label_max_length
    # 255 chars
    test_s = "123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345"
    assert (test_s.size == 255) 
    # limit is 255
    data_points(:pushup).label = test_s
    assert data_points(:pushup).valid?
  end
  
  def test_label_min_length
    data_points(:pushup).label = "a"
    assert data_points(:pushup).valid?
  end

  # date
  # %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
  
  def test_date_nil
    data_points(:pushup).date = nil
    assert !data_points(:pushup).valid?
  end
  
  def test_date_blank
    data_points(:pushup).date = ""
    assert !data_points(:pushup).valid?
  end
  
  def test_date_alphanumeric
    data_points(:pushup).date = "asd3r"
    assert !data_points(:pushup).valid?
  end
  
  # datum
  # %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  def test_datum_one_tag
    point = users(:fred).data_points.build
    point.date = Date.today
    point.datum = "10 blurgs, tag1"
    # valid
    assert point.valid?
    # saves
    assert point.save
    # saved correctly
    point = users(:fred).data_points.find_by_label("blurgs")    
    assert !point.nil?
    assert_equal 1, point.tag_list.size
    assert_equal "tag1", point.tag_list.first
  end
  
  def test_datum_no_tag
    point = users(:fred).data_points.build
    point.date = Date.today
    point.datum = "10 blurgs"
    # valid
    assert point.valid?
    # saves
    assert point.save
    # saved correctly
    point = users(:fred).data_points.find_by_label("blurgs")    
    assert !point.nil?
    assert_equal 0, point.tag_list.size
  end

  def test_datum_float_quantity
    point = users(:fred).data_points.build
    point.date = Date.today
    point.datum = "10.54 blurgs, tag1"
    # valid
    assert point.valid?
    # saves
    assert point.save
    # saved correctly
    point = users(:fred).data_points.find_by_label("blurgs")    
    assert !point.nil?
    assert_equal 10.54, point.data
    assert_equal 1, point.tag_list.size
    assert_equal "tag1", point.tag_list.first
  end
  
  def test_datum_negative_quantity
    point = users(:fred).data_points.build
    point.date = Date.today
    point.datum = "-10 blurgs, tag1"
    # valid
    assert point.valid?
    # saves
    assert point.save
    # saved correctly
    point = users(:fred).data_points.find_by_label("blurgs")    
    assert !point.nil?
    assert_equal -10, point.data
    assert_equal 1, point.tag_list.size
    assert_equal "tag1", point.tag_list.first
  end
  
  def test_datum_positive_quantity
    point = users(:fred).data_points.build
    point.date = Date.today
    point.datum = "+10 blurgs, tag1"
    # valid
    assert point.valid?
    # saves
    assert point.save
    # saved correctly
    point = users(:fred).data_points.find_by_label("blurgs")    
    assert !point.nil?
    assert_equal +10, point.data
    assert_equal 1, point.tag_list.size
    assert_equal "tag1", point.tag_list.first
  end
  
  def test_datum_positive_float_quantity
    point = users(:fred).data_points.build
    point.date = Date.today
    point.datum = "+0.34 blurgs, tag1"
    # valid
    assert point.valid?
    # saves
    assert point.save
    # saved correctly
    point = users(:fred).data_points.find_by_label("blurgs")    
    assert !point.nil?
    assert_equal +0.34, point.data
    assert_equal 1, point.tag_list.size
    assert_equal "tag1", point.tag_list.first
  end
  
  def test_datum_no_label
    point = users(:fred).data_points.build
    point.date = Date.today
    point.datum = "30, tag1"
    # validations
    assert_equal 30, point.data
    assert point.label.blank?
    assert_equal 1, point.tag_list.size
    assert_equal "tag1", point.tag_list.first
    # validation
    assert !point.valid?
  end
  
  def test_datum_no_label_no_tags
    point = users(:fred).data_points.build
    point.date = Date.today
    point.datum = "30"
    # validations
    assert_equal 30, point.data
    assert point.label.blank?
    assert_equal 0, point.tag_list.size
    # validation
    assert !point.valid?
  end
  
  def test_datum_bad_quantity_no_label_no_tags
    point = users(:fred).data_points.build
    point.date = Date.today
    point.datum = "rubbish"
    # validations
    assert_equal 0, point.data
    assert point.label.blank?
    assert_equal 0, point.tag_list.size
    # validation
    assert !point.valid?
  end
  
  def test_datum_nil
    point = users(:fred).data_points.build
    point.date = Date.today
    point.datum = nil
    # validations
    assert point.data.nil?
    assert point.label.nil?
    assert_equal 0, point.tag_list.size
    # validation
    assert !point.valid?
  end
  
  def test_datum_blank
    point = users(:fred).data_points.build
    point.date = Date.today
    point.datum = " \t"
    # validations
    assert point.data.nil?
    assert point.label.nil?
    assert_equal 0, point.tag_list.size
    # validation
    assert !point.valid?
  end
  

end
