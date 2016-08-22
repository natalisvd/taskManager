define [
  'chaplin'
  'app/base/collection'
  'app/models/task_stage'
], (Ch, Collection, TaskStage) ->
  'use strict'

  class TaskStages extends Collection

    model: TaskStage