module Api
  class UsersController < ApiController

    #GET /api/c_user
    def c_user
      render :json => current_user
    end

    #GET /api/projects/:project_id/users
    # def index
    #   project = Project.find(params[:project_id])
    #   users_ids_with_access = project.users.pluck(:id)
    #   users = User.where.not(:id => project.creator_id)
    #
    #   result = users.as_json
    #   result.each do |user|
    #     if user['id'] == project.creator_id
    #       user['access_to_project'] = 'creator'
    #     elsif users_ids_with_access.include?(user['id'])
    #       user['access_to_project'] = 'true'
    #     else
    #       user['access_to_project'] = 'false'
    #     end
    #   end
    #
    #   render :json => result.to_json
    # end

  end
end