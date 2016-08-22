module Api
  class ProjectsController < ApiController

    # GET /api/projects
    #params {project_id=12}
    def index
      projects = current_user.own_projects.union(current_user.projects)

      result = {projects: projects.as_json}

      if Project.exists?(params[:project_id])
        #set active
        result[:projects].map { |project| project['active'] = project['id'] == params[:project_id].to_i ? true : false }
        #select users
        project = Project.find(params[:project_id])
        users_ids_with_access = project.users.pluck(:id)
        users = User.all
        uresult = users.as_json
        uresult.each do |user|
          if user['id'] == project.creator_id
            user['access_to_project'] = 'creator'
          elsif users_ids_with_access.include?(user['id'])
            user['access_to_project'] = 'true'
          else
            user['access_to_project'] = 'false'
          end
        end
        result['users'] = uresult
        #attach files
        attach_files = project.attach_files
        active = result[:projects].detect{|project| project['id'] == params[:project_id].to_i}
        active[:attach_files] = attach_files
      end
      render :json => result.to_json
    end

    # POST /api/projects
    def create
      project = current_user.own_projects.new(params_project)
      if project.save
        render :json => {success: true, project: project}.to_json
      else
        render :json => {success: false, errors: project.errors}.to_json
      end
    end

    #PUT /api/projects/:project_id
    def update
      project = Project.find(params[:id])
      if project.update_attributes(params_project)
        render :json => {success: true}.to_json
      else
        render :json => {success: false, errors: task.errors}.to_json
      end
    end

    #PUT /api/projects/:project_id/access
    def give_access
      project = Project.find(params[:project_id])
      if project.creator_id == current_user.id
        project.user_to_projects.create(:user_id => params[:user_id])
        render :json => {success: true, access_to_project: 'true'}
      else
        render :json => {success: false}
      end
    end

    #DELETE /api/projects/:project_id/access
    def deny_access
      project = Project.find(params[:project_id])
      if project.creator_id == current_user.id
        project.user_to_projects.where(:user_id => params[:user_id]).destroy_all()
        render :json => {success: true, access_to_project: 'false'}
      else
        render :json => {success: false}
      end
    end

    #PUT /api/projects/:project_id/upload_file
    def upload_file
      project = Project.find(params[:project_id])
      attach_file = project.attach_files.new(params_file)
      if attach_file.save
        render :json => {success: true, attach_file: attach_file}.to_json
      else
        render :json => {success: false, errors: attach_file.errors}.to_json
      end

    end

    #DELETE /api/projects/:project_id/remove_file
    def remove_file
      render :json => {success: false}
    end

    private
    def params_project
      params.require(:project).permit(:id, :name, :description, :creator_id, :created_at, :updated_at)
    end

    def params_file
      params.require(:attach_file).permit(:path)
    end
  end
end