class Organization < ActiveRecord::Base
  belongs_to :admin, :class_name => 'User', :foreign_key => 'admin_id'
  has_many :users

  validates_presence_of :name
  validates_presence_of :admin
end
