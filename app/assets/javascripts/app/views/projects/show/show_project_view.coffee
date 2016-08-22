define [
  'chaplin'
  'app/base/view'
  'text!app/views/projects/show/show_project.hbs'
  'app/views/projects/show/access/users_list_view'
  'app/views/projects/show/graph/graph_view'
  'app/views/projects/show/tasks/tasks_list_view'
  'app/views/projects/show/files/files_list_view'
], (Ch, View, template, UsersListView, GraphView, TasksListView, FilesListView) ->
  'use strict'

  class ShowProjectView extends View

    template: template
    container: '.show-project-container'
    className: 'show-project-view'
    autoRender: true
    stage: 'project-extended'#'tasks/project-extended'
    containerMethod: 'html'

    events:
      'click .toggle-tasks': 'toggleView'
      'keyup .project-name': 'changeName'
      'keyup .project-description': 'changeDescription'
      'blur .project-name': 'updateProject'
      'blur .project-description': 'updateProject'

    initialize: ->
      @stage = localStorage.getItem('show-project-stage')
      super

    getTemplateData: ->
      data = super
      data.stage = @stage
      data.creator = @model.creator().getAttributes()
      data.is_creator = @model.creator().get('id') is Ch.m.user.get('id')
      data.task_row_class = if @stage is 'tasks-extended' then 'extended' else 'intended'
      data.project_row_class = if @stage is 'tasks-extended' then 'intended' else 'extended'
      data

    toggleView: ->
      if @stage is 'tasks-extended'
        @$('.project-details-row').removeClass('intended')
        @$('.show-tasks-row').removeClass('extended')
        @$('.project-details-row').addClass('extended')
        @$('.show-tasks-row').addClass('intended')
        @stage = 'project-extended'
      else
        @$('.project-details-row').removeClass('extended')
        @$('.show-tasks-row').removeClass('intended')
        @$('.project-details-row').addClass('intended')
        @$('.show-tasks-row').addClass('extended')
        @stage = 'tasks-extended'
      localStorage.setItem('show-project-stage', @stage)

    afterRender: ->
      users_list_view = new UsersListView(container: @$('#access'))
      @subview('users_list_view', users_list_view)
      graph_view = new GraphView(container: @$('#graph'), model: @model)
      @subview('graph_view', graph_view)
      files_list_view = new FilesListView(container: @$('#files'), collection: @model.files())
      @subview('files_list_view', files_list_view)
      tasks_list_view = new TasksListView(container: @$('.tasks-bar'), collection: @model.tasks())
      @subview('tasks_list_view', tasks_list_view)
#      @$('a[href$="#graph"]').click()

    changeName: (e) ->
      @model.set('name', $(e.currentTarget).val())

    changeDescription: (e) ->
      @model.set('description', $(e.currentTarget).val())

    updateProject: ->
      @model.save()