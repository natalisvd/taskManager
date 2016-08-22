define [
  'chaplin'
  'text!app/views/projects/show/tasks/task_list.hbs'
  'app/base/collection_view'
  'app/views/projects/show/tasks/task_item_view'
], (Ch, template, CollectionView, TaskItemView) ->
  'use strict'

  class TasksListView extends CollectionView

    itemView: TaskItemView
    autoRender: true
    template: template
    className: 'tasks-list-view'
    listSelector: '.list'

    events:
      'click .new-task': 'createTask'

    initialize: ->
      @collection.fetch()
      super

    createTask: (e) ->
      @collection.newTask()