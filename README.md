User(Devise) — класс для додавання нових співробітників. Також описує  логіку їх поведінки та відображає данні цього модулю.  В цьому класі прописані необхідні методи для звязку з іншими таблицями в базі данних, а також всі необхідні перевірки щодо валідності введених данних. На Лістингу 1 Можна побачити модель User .
%br	
Лістинг 1 Модель User
class User < ActiveRecord::Base
  devise :database_authenticatable,:recoverable, :rememberable, :trackable, :validatable
  has_many :ideas
  has_many :my_projects, :class_name => 'Project', :foreign_key => 'user_id'
  has_many :user_to_projects
  has_many :projects, :through => :user_to_projects
  has_many :tasks_requester,class_name: Task, foreign_key: :requester_id
  has_many :tasks_owner,class_name: Task, foreign_key: :owner_id
  has_many :comments
  has_many :news,:dependent => :destroy
  mount_uploader :avatar, AvatarUploader
  has_many :notes, dependent: :destroy
  has_many :folders, dependent: :destroy
  has_many :weeks, dependent: :destroy
  has_many :time_works, dependent: :destroy
  def role?(r)
    role.include? r.to_s
  end
  validates :password, length: { minimum: 8 }
  VALID_EMAIL_REGEX=/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :position, presence: true, length: maximum:20 }
  validates :birthday, presence: true
  validates :salary, presence: true,length:{maximum:10}
  validates :employment_date, presence: true
  validates :skype, presence: true, length:{maximum:30}
  validates :phone, presence: true, length:{is:10 }
  validates :name, presence: true, length:{maximum:25 }			 validates :patronymic, presence: true, length:{maximum:25}
%br
Task — клас  що описує задачі, логіку їх поведінки та відображає данні цього модулю. Тут прописані необхідні методи для звязку з іншими таблицями в базі данних. На лістингу 2 можна побачити модель Task. Задача залежить від проекту.  Створювати та переглядати її можна лише перейшовши у конкретний проект 

Лістинг 2 Модель Task
class Task < ActiveRecord::Base
  belongs_to :project
  belongs_to :owner, class_name: User, foreign_key: :owner_id
  belongs_to :requester, class_name: User, foreign_key: :requester_id
  belongs_to :parent, :class_name => Task, :foreign_key => "parent_id"
  has_many :children, :class_name => Task, :foreign_key => "parent_id", :dependent => :destroy
  has_many :comments, :as => :commentable
end


Project — клас що описує проекти, логіку їх поведінки та відображає данні цього модулю. Проекти мають звязок  з юзерами та задачами Лістинг 3. Данні проекту відображаються на сторінці /progect/:id. Зліва у нас список проектів та кнопка для створення проекту ця кнопка створює новий проект й відображає його зліва першим у списку проектів  рис. 17  де потрібно ввести назву для створення проекту  якщо поле буде пусте проект видалиться автоматично.

Лістинг 3 Модель Project.
class Project < ActiveRecord::Base
  belongs_to :creator, :foreign_key => 'user_id', :class_name => 'User'
  has_many :comments, :as => :commentable, :dependent => :destroy
  has_many :tasks, :dependent => :destroy
  has_many :user_to_projects, :dependent => :destroy
  has_many :users, :through => :user_to_projects
end


Comment — описує коментарії, логіку їх поведінки та відображає данні цього    модулю.
UserToProject — класс що описує звязок юзерів та проекту (Лістинг 4.) .Цей класс має звязок один до багатьох. Він створенний як проміжний для того щоб розбити звязок багато до багатьох. Один проект може мати багато учасників , один  учасник може мати багаьо проектів.  

Лістинг 4 Модель UserToProject 
class UserToProject < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
end

FileComment — описує файли які відносяться до коментарів, логіку їх поведінки та відображає данні цього  модулю.
Note — описує примітки, звязки в базі данних, логіку їх поведінки(Лістинг 5.). На лістингу 5 видно що записи повязані з  користувачами, також вони можуть містити в собі файли.

Лістинг 5 Модель Note
class Note < ActiveRecord::Base
  belongs_to :user
  belongs_to :notable, :polymorphic => true
  has_many :items, :dependent => :destroy
  has_many :note_files, :dependent => :destroy
  accepts_nested_attributes_for :items, :allow_destroy => true
  accepts_nested_attributes_for :note_files, :allow_destroy => true


Notes Controller — класс що відповідає за всі дії з записами, такі як створення, редагування,  перегляд, видалення. Також тут написаний доступ до полів в базі классу Note. На Лістингу 5.1 можна побачити метод що створює запис про збереження екземпляру классу Note.

Лістинг 5.1 Контроллер Notes
class NotesController < ApplicationController
def create
  if note_params['notable_type'] == 'Folder'
    notable_id = nil || Folder.where(:name=> note_params['notable_id']).first.id
  else
    notable_id = note_params['notable_id']
  end
  note = current_user.notes.new(:notable_id => notable_id, :notable_type=> note_params['notable_type'], :title=> note_params['title'], :content=> note_params['content'],
                                :date => note_params['date'], :color =>note_params['color'], :tags => note_params['tags'])
  if note_params['items_attributes']
    note_params['items_attributes'].each do |key, item|
      note.items.build(item)
    end
  end
  if note_params['not_files_attributes']
    note_params['not_files_attributes'].each do |key, not_file|
      note.note_files.build(not_file)
    end
  end
  if note.save
    @notes = Note.where(:date => note_params['date'], :notable_type=>'Folder', :user_id => current_user).order(:created_at)
    if note_params['notable_type'] == 'Folder'
      render :partial => 'show_note', locals: {notes: @notes}
    end
  else
    render json: {errors: note.errors}
  end
end
def note_params
  params.require(:note).permit(:notable_type, :notable_id, :title, :content,:color, :date, :tags, items_attributes: [:item, :status, :note_id], note_files_attributes: [:file_path, :note_id] )
End

Scheduler — класс що описує розклад, звязки в базі данних ,логіку їх поведінки та відображає данні цього модулю(Лістинг 6.). Цей розділ був створенний по більшій мірі для співробітників - студентів так як тут йде планування часу на 2 тижні (чисельник і знаменик)  але й всі інші з задоволеням користуються цим розділом для планування свого часу на наступні 2 тижні.

Лістинг 6 Модель Sheduler
class Schedule < ActiveRecord::Base
  belongs_to :week
  validates :description, :start_hours, :start_minutes,
          :duration_hours, :duration_minutes, :week_id,
            :day_number, presence: true
  validates :description, length: { in: 1..55 }
  validates :start_hours, :duration_hours, :numericality => { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100 }
  validates :start_minutes, :duration_minutes, inclusion: { in: [0, 15, 30, 45] }
  validates :day_number, inclusion: { in: 1..7 }
  validates :week_id, numericality: { only_integer: true }
  end
end

Sheduller Controller — класс що відповідає за всі дії з розкладом, такі як створення, редагування,  перегляд, видалення. Також тут написаний доступ до полів в базі классу Sheduller. На Лістингу 6.1 можна побачити метод що редагує запис у базі классу Sheduller та метод що выдображає данні цього класу .

Лістинг 6.1 Контроллер Sheduller
class SchedulesController < ApplicationController

def update
  @schedule = Schedule.find(params['s_id'])
  @schedule.update_attributes(description: params['description'],comment: params['comment'], start_hours: params['start_hours'], start_minutes: params['start_minutes'],
                              duration_hours: params['duration_hours'], duration_minutes: params['duration_minutes'], color: params['color'])
  render json: {success: true, sch: @schedule}
end
еnd
def show
  @schedule = Schedule.find(params['schedule_id'])
  render json: {success: true, id: @schedule.id, start_hours: @schedule.start_hours, start_minutes: @schedule.start_minutes,
                description: @schedule.description,comment: @schedule.comment, duration_hours: @schedule.duration_hours, duration_minutes: @schedule.duration_minutes, day_number: @schedule.day_number, color: @schedule.color }
