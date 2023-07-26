class DataPoint < ActiveRecord::Base
  
  # relationships
  belongs_to :user
  
  # tags
  # http://agilewebdevelopment.com/plugins/acts_as_taggable_on_steroids
  acts_as_taggable
  
  # accessable vars
  attr_accessible :label, :data, :date, :datum, :tag_list
  
  # validation
  validates_presence_of :data, :label, :date, :user
  validates_numericality_of :data, :allow_blank => :true
  validates_length_of :label, :in => 1..255, :allow_blank => :true
  
  # scopes
  named_scope :bydate, :order=>"date DESC"
  named_scope :today, lambda { {:conditions => ["date=?", Date.today]} }
  named_scope :yesterday, lambda { {:conditions => ["date=?", Date.yesterday]} }

  # pagination
  cattr_reader :per_page
  @@per_page = 30




  # number context, tag1, tag2, tag3
  def datum=(datum)
    return if datum.blank?
    return if (datum=datum.strip).blank?
    # [number context] [tag1] [tag2] [tag3]
    comma_split = datum.split(',')
    # build the data and label    
    split2 = comma_split[0].split(' ', 2)
    self.data = split2[0].strip
    self.label = split2[1].strip if split2.size == 2
    # tag list
    if comma_split.size > 1            
      comma_split.delete_at(0)
      self.tag_list = comma_split.join(', ')
    end
  end
  
  def datum
    [[self.data, self.label].join(' '), self.tag_list].join(', ') if valid?
  end
  

  
  
  
end
