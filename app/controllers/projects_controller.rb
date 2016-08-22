class ProjectsController < ApplicationController

  layout 'app'

  #GET /projects
  def index
    respond_to do |format|
      format.html { render text: nil, layout: true }
    end
  end

  # GET /projects/:id
  # def show
  #   respond_to do |format|
  #     format.html { render text: nil, layout: true }
  #   end
  # end

  # def add_member_to_project
  #   @project = Project.find(params[:project_id])
  #   @project.user_to_projects.create(:user_id => params[:user_to_project][:user_id])
  #   respond_to do |format|
  #     format.js {render inline: "location.reload();" }
  #   end
  # end
end
