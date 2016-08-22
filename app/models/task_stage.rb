class TaskStage < ActiveRecord::Base
  belongs_to :task


  def start_date
    self.created_at
  end

  def end_date
    self.updated_at
  end
end
