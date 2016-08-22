define [
  'chaplin'
  'app/base/view'
  'text!app/views/projects/show/tasks/show_task.hbs'
  'app/views/projects/show/tasks/assigned_to_users_list_view'
], (Ch, View, template, AssignedToUsersListView) ->
  'use strict'

  class ShowTaskView extends View

    template: template
    container: '.show-task-bar'
    className: 'show-task-view container-fluid'
    autoRender: true
    containerMethod: 'html'

    events:
      'keyup .task-title': 'changeTitle'
      'keyup .task-description': 'changeDescription'
      'dp.change #datetimepicker1': 'changeReleaseDate'
      'blur .task-title': 'updateTask'
      'blur .task-description': 'updateTask'
      'click .change-status-panel .btn': 'changeStatus'

    initialize: ->
      @listenTo @model, 'change:status', @displayButtons
      @listenTo @model, 'change:status', @changeStatusCallback
      super

    afterRender: ->
      @displayButtons()
      assigned_to_users_list_view = new AssignedToUsersListView(container: @$('.assigned-to'), task: @model)
      @subview('assigned_to_users_list_view', assigned_to_users_list_view)
      @$('#datetimepicker1').datetimepicker(
        format: 'DD/MM/YYYY'
        defaultDate: @model.get('release_date')
      )
      if Ch.m.projects.getActiveProject().get('creator_id') isnt Ch.m.user.get('id')
        @$('.task-release-date').attr('disabled', true)

    getTemplateData: ->
      data = super
      data.is_creator = Ch.m.projects.getActiveProject().get('creator_id') is Ch.m.user.get('id')
      data.status_html = @taskStatus()
      data

    changeTitle: (e) ->
      @model.set('title', $(e.currentTarget).val())

    changeDescription: (e) ->
      @model.set('description', $(e.currentTarget).val())

    changeReleaseDate: (e) ->
      @model.set('release_date', @$('.task-release-date').val())
      @model.save()

    updateTask: ->
      @model.save()

    taskStatus: ->
      statuses =
        'opened': '<span class="label label-primary">Opened</span>'
        'in_progress': '<span class="label label-info">In progress</span>'
        'paused': '<span class="label label-warning">Paused</span>'
        'finished': '<span class="label label-default">Finished</span>'
        'returned': '<span class="label label-danger">Returned</span>'
        'closed': '<span class="label label-success">Closed</span>'
      statuses[@model.get('status')]

    changeStatusCallback: (status) ->
      @$('.status-panel div').html('Состояние ' + @taskStatus())

    displayButtons: ->
      status = @model.get('status')
      @$('.change-status-panel .btn').hide()
      if (status is 'opened' or status is 'returned') and Ch.m.user.matchId(@model.get('executor_id'))
        @$('.start-btn').css('display', 'inline-block')
      else if status is 'in_progress' and Ch.m.user.matchId(@model.get('executor_id'))
        @$('.pause-btn, .finish-btn').css('display', 'inline-block')
      else if status is 'paused' and Ch.m.user.matchId(@model.get('executor_id'))
        @$('.continue-btn').css('display', 'inline-block')
      else if status is 'finished' and Ch.m.projects.getActiveProject().get('creator_id') is Ch.m.user.get('id')
        @$('.return-btn, .close-btn').css('display', 'inline-block')

    changeStatus: (e) ->
#      @model.set('status', $(e.currentTarget).data('type'))
      @model.changeStatus($(e.currentTarget).data('type'))