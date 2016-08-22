class Project < ActiveRecord::Base
  belongs_to :creator, :foreign_key => 'creator_id', :class_name => 'User', required: true, :dependent => :destroy
  has_many :user_to_projects, :dependent => :destroy
  has_many :users, :through => :user_to_projects

  has_many :tasks, :dependent => :destroy
  has_many :attach_files, :as => :fileable

  validates :name, :presence => true, length: {maximum: 30}

  def created_at
    super.strftime("%F(%H:%M)")
  end
end