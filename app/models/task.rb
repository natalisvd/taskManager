class Task < ActiveRecord::Base
  belongs_to :project
  belongs_to :executor, class_name: User, foreign_key: :executor_id #исполнитель
  belongs_to :parent, :class_name => Task, :foreign_key => "parent_id"
  has_many :children, :class_name => Task, :foreign_key => "parent_id", :dependent => :destroy
  has_many :comments, :as => :commentable, :dependent => :destroy
  has_many :attach_files, :as => :fileable, :dependent => :destroy
  has_many :task_stages, :dependent => :destroy


  validates :title, :presence => true, length: {maximum: 30}
  #validate create update if creator of project

  def change_status(status)
    #opened, in_progress, paused, finished, returned, closed
    self.update_attributes(status: status)
    last_stage = self.task_stages.last
    if last_stage
      last_stage.update_attributes(updated_at: DateTime.now)
    end
    self.task_stages.create(status: status)
  end

  def switch_status
    # statuses = ['opened', 'in_progress', 'paused', 'finished', 'returned', 'closed']
    case self.status
      when 'closed'
        return
      when nil
        next_status = 'opened'
      when 'opened'
        next_status = 'in_progress'
      when 'in_progress'
        next_status = ['paused', 'finished'].sample
      when 'paused'
        next_status = 'in_progress'
      when 'finished'
        next_status = ['returned', 'closed'].sample
      when 'returned'
        next_status = 'in_progress'
    end
    self.update_attributes(status: next_status)
    if next_status == 'closed'
      created_at = self.task_stages.first.created_at
      updated_at = self.task_stages.last.updated_at
    else
      if self.task_stages.last
        created_at = self.task_stages.last.updated_at
      else
        created_at = (15..20).to_a.sample.hours.ago
      end
      updated_at = created_at + (1..2).to_a.sample.hours
    end
    self.task_stages.create(status: next_status, created_at: created_at, updated_at: updated_at)
  end
end
