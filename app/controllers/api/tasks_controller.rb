module Api
  class TasksController < ApiController

    #GET /api/projects/:project_id/tasks
    def index
      tasks = Project.find(params[:project_id]).tasks.includes(:task_stages)
      result = tasks.as_json
      tasks.map.with_index do |task, i|
        result[i]['task_stages'] = task.task_stages.as_json
        #TODO fix last or first
        last = result[i]['task_stages'].first #first or last
        if last && last['status'] != 'closed'
          last['updated_at'] = DateTime.now
        end
        # if result[i]['task_stages'].first['status'] != 'closed'
        #   result[i]['task_stages'].first['updated_at'] = DateTime.now
        # end
      end

      render :json => result.to_json
    end

    #POST /api/projects/:project_id/tasks
    def create
      project = Project.find(params[:project_id])
      task = project.tasks.new(params_task)
      if task.save
        task.change_status('opened')
        render :json => {success: true, task: task}.to_json
      else
        render :json => {success: false, errors: task.errors}.to_json
      end
    end

    #PUT /api/projects/:project_id/tasks/:task_id
    def update
      task = Task.find(params[:id])
      if task.update_attributes(params_task)
        render :json => {success: true}.to_json
      else
        render :json => {success: false, errors: task.errors}.to_json
      end
    end

    #PUT /api/projects/:project_id/tasks/:task_id/change_status
    def change_status
      p '----'*100
      p params
      task = Task.find(params[:task_id])
      task.change_status(params[:status])
      render :json => {success: true}
    end

    private
    def params_task
      params.require(:task).permit(:id, :title, :description, :project_id, :executor_id, :parent_id, :status, :time_estimate, :elapsed_time, :release_date, :created_at, :updated_at)
    end
  end
end