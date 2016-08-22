class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable :registerable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable
  mount_uploader :avatar, AvatarUploader

  has_many :user_to_projects, :dependent => :destroy
  has_many :projects, :through => :user_to_projects
  has_many :own_projects, :class_name => 'Project', :foreign_key => 'creator_id', :dependent => :destroy


  has_many :tasks_requester,class_name: Task, foreign_key: :executor_id
  has_many :tasks_owner,class_name: Task, foreign_key: :owner_id



  def role?(r)
    role.include? r.to_s
  end
  # validates :password, length: { minimum: 8 }
  # VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  # validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  # validates :position, presence: true, length: { maximum: 200 }
  # validates :birthday, presence: true
  # validates :salary, presence: true, length: { maximum: 10 }
  # validates :employment_date, presence: true
  # validates :skype, presence: true, length: { maximum: 30 }
  # validates :phone, presence: true, length: { is: 10 }
  validates :name, presence: true, length: { maximum: 25 }
  validates :patronymic, presence: true, length: { maximum: 25 }





  def self.available_for_add_to_project(project_id)
    p = Project.find(project_id)
    ids = []
    ids << p.creator.id
    ids.concat(p.user_to_projects.pluck(:user_id))
    where.not(:id => ids)
  end

end
