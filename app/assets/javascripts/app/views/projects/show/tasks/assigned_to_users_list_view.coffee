define [
  'chaplin'
  'text!app/views/projects/show/tasks/assigned_to_users_list.hbs'
  'app/base/collection_view'
  'app/views/projects/show/tasks/assigned_to_user_item_view'
], (Ch, template, CollectionView, AssignedToUserItemView) ->
  'use strict'

  class AssignedToUsersListView extends CollectionView

    itemView: AssignedToUserItemView
    autoRender: true
    template: template
    className: 'assigned-to-users-list-view col-md-12 text-center'
    listSelector: '.dropdown-menu'

    initialize: (options) ->
      @task = options.task
      @listenTo @task, 'change:executor_id', @changeExecutorCallback
      @collection = Ch.m.users
      super

    getTemplateData: ->
      data = super
      data.executor = @task.executor()?.getAttributes()
      data.is_creator = Ch.m.projects.getActiveProject().get('creator_id') is Ch.m.user.get('id')
      data

    filterer: (item, index) ->
      item.get('access_to_project') is 'true' or item.get('access_to_project') is 'creator'

    changeExecutorCallback: ->
      @$('.task-executor-name').text(@task.executor().get('name') + ' ' + @task.executor().get('surname'))

    initItemView: (model) ->
      if @itemView
        new @itemView {autoRender: false, task: @task, model}
      else
        throw new Error 'The CollectionView#itemView property ' +
            'must be defined or the initItemView() must be overridden.'