define [
  'chaplin'
  'app/base/controller'
  'app/views/navbar/navbar_view'
  'app/views/projects/projects_view'
  'app/views/projects/projects_list_view'
  'app/views/projects/show/show_project_view'
  'app/models/projects'
  'app/views/projects/show/tasks/show_task_view'
  'app/views/projects/show/tasks/tasks_list_view'
], (Ch, Controller, NavbarView, ProjectsView, ProjectsListView,
    ShowProjectView, Projects, ShowTaskView, TasksListView) ->
  'use strict'

  class ProjectsController extends Controller

    beforeAction: (params, route, options, executeAction) ->
      @reuse 'navbar', NavbarView
      @reuse 'p_view', ProjectsView

    initialize: ->
      super

    index: (params, route, options) ->
      project_id = parseInt(options.query.project_id)
      task_id = parseInt(options.query.task_id)

      @reuse 'projects',
        compose: ->
          Ch.m.projects = @projects = new Projects()
          @projects_list_view = new ProjectsListView(collection: @projects)
        check: ->
          @projects

      data = if project_id then {project_id: project_id} else {}
      Ch.m.projects.fetch(data: data).then =>
        active_project = Ch.m.projects.getActiveProject()

        @reuse 'show_project',
          compose: ->
            if active_project
              Ch.m.publish('checkActiveProject', project_id)
              @shos_project_view = new ShowProjectView(model: active_project)
          check: ->
            project_id is Ch.m.projects.getActiveProject().get('id')

        if active_project
          active_project.tasks().active_task_id = task_id
          active_project.tasks().fetch().then =>
            active_task = active_project.tasks().get(task_id)
            if active_task
              Ch.m.publish('checkActiveTask', task_id)
              @st_view = new ShowTaskView(model: active_task)