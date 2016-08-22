define [
  'chaplin'
  'app/base/view'
  'text!app/views/projects/show/graph/graph.hbs'
], (Ch, View, template) ->
  'use strict'

  class GraphView extends View

    template: template
    className: 'graph-view'
    autoRender: true
    currInt: '1day'

    events:
      'click .dropdown-menu a': 'changeInterval'

#    tasks: [
#      {
#      'startDate': 	new Date(2016,5,20,8)
#      'endDate': 	new Date(2016,5,20,9)
#      'taskName': 'E Job'
#      'status': 'OPEN'
#      }
#      {
#        'startDate': 	new Date(2016,5,20,9)
#        'endDate': 	new Date(2016,5,20,10)
#        'taskName': 'E Job'
#        'status': 'INPROGRESS'
#      }
#      {
#        'startDate': 	new Date(2016,5,20,10)
#        'endDate': 	new Date(2016,5,20,10,30)
#        'taskName': 'E Job'
#        'status': 'PAUSE'
#      }
#      {
#        'startDate': 	new Date(2016,5,20,10,30)
#        'endDate': 	new Date(2016,5,20,11)
#        'taskName': 'E Job'
#        'status': 'INPROGRESS'
#      }
#      {
#        'startDate': 	new Date(2016,5,20,11)
#        'endDate': 	new Date(2016,5,20,12)
#        'taskName': 'E Job'
#        'status': 'CHECK'
#      }
#      {
#        'startDate': 	new Date(2016,5,20,12)
#        'endDate': 	new Date(2016,5,20,12,30)
#        'taskName': 'E Job'
#        'status': 'RETURN'
#      }
#      {
#        'startDate': 	new Date(2016,5,20,12,30)
#        'endDate': 	new Date(2016,5,20,13)
#        'taskName': 'E Job'
#        'status': 'INPROGRESS'
#      }
#      {
#        'startDate': 	new Date(2016,5,20,13)
#        'endDate': 		new Date(2016,5,20,13,30)
#        'taskName': 'E Job'
#        'status': 'CHECK'
#      }
#      #A Job-----------------------------------------
#      {
#        'startDate': 	new Date(2016,5,20,9)
#        'endDate': 	new Date(2016,5,20,10)
#        'taskName': 'A Job'
#        'status': 'OPEN'
#      }
#      {
#        'startDate': 	new Date(2016,5,20,10)
#        'endDate': 	new Date(2016,5,20,10,30)
#        'taskName': 'A Job'
#        'status': 'INPROGRESS'
#      }
#      {
#        'startDate': 	new Date(2016,5,20,10,30)
#        'endDate': 	new Date(2016,5,20,11,30)
#        'taskName': 'A Job'
#        'status': 'CHECK'
#      }
#      {
#        'startDate': 	new Date(2016,5,20,9)
#        'endDate': 	new Date(2016,5,20,11,30)
#        'taskName': 'A Job'
#        'status': 'CLOSED'
#      }
#    ]
    taskStatus:
      'opened': 'bar-opened'
      'in_progress': 'bar-in-progress'
      'paused': 'bar-paused'
      'finished': 'bar-finished'
      'returned': 'bar-returned'
      'closed': 'bar-closed'
#    taskNames: [
#      'D Job'
#      'P Job'
#      'E Job'
#      'A Job'
#      'N Job'
#    ]

    initialize: (options) ->
      @collection = @model.tasks()
      @listenTo @collection, 'all', @render
      super

    render: ->
      super

    getTemplateData: ->
      {currInt: @currInt}

    changeInterval: (e) ->
      e.preventDefault()
      @currInt = $(e.currentTarget).text()
      @$('.currInt').text(@currInt)
      @afterRender(@currInt)

    afterRender: (timeDomainString = '1day') ->
      window.a = @
      @func = _.debounce (timeDomainString) =>
        d3.select("svg").remove();
        @taskNames = @model.tasks().pluck('title')
        @tasks = []
        @model.tasks().map (task) =>
          task.taskStages().models.map (stage) =>
            a = {}
            a.startDate = new Date(Date.parse(stage.get('created_at')))
            a.endDate = new Date(Date.parse(stage.get('updated_at')))
            a.taskName = task.get('title')
            a.status = stage.get('status')
            @tasks.push(a)
        height = @tasks.length * 7
#        width = @$el.width() * 0.75
        width = $('.project-details').width() * 0.75
        @tasks.sort (a, b) =>
          a.endDate - (b.endDate)
          maxDate = @tasks[@tasks.length - 1].endDate
        @tasks.sort (a, b) =>
          a.startDate - (b.startDate)
        minDate = @tasks[0].startDate
        format = '%H:%M'
        @gantt = d3.gantt().taskTypes(@taskNames).taskStatus(@taskStatus).tickFormat(format).height(height).width(width)
        @gantt.timeDomainMode 'fixed'
        @changeTimeDomain timeDomainString
        @gantt @tasks
      , 500 unless @func
      @func(timeDomainString)

    changeTimeDomain: (timeDomainString) ->
      @timeDomainString = timeDomainString
      switch @timeDomainString
        when '1hr'
          format = '%H:%M:%S'
          @gantt.timeDomain [
            d3.time.hour.offset(@getEndDate(), -1)
            @getEndDate()
          ]
        when '3hr'
          format = '%H:%M'
          @gantt.timeDomain [
            d3.time.hour.offset(@getEndDate(), -3)
            @getEndDate()
          ]
        when '6hr'
          format = '%H:%M'
          @gantt.timeDomain [
            d3.time.hour.offset(@getEndDate(), -6)
            @getEndDate()
          ]
        when '1day'
          format = '%H:%M'
          @gantt.timeDomain [
            d3.time.day.offset(@getEndDate(), -1)
            @getEndDate()
          ]
        when '1week'
          format = '%a %H:%M'
          @gantt.timeDomain [
            d3.time.day.offset(@getEndDate(), -7)
            @getEndDate()
          ]
        else
          format = '%H:%M'
      @gantt.tickFormat format
      @gantt.redraw @tasks
      return

    getEndDate: ->
      lastEndDate = Date.now()
      if @tasks.length > 0
        lastEndDate = @tasks[@tasks.length - 1].endDate
      lastEndDate

#    addTask: ->
#      lastEndDate = @getEndDate()
#      taskStatusKeys = Object.keys(@taskStatus)
#      taskStatusName = taskStatusKeys[Math.floor(Math.random() * taskStatusKeys.length)]
#      taskName = @taskNames[Math.floor(Math.random() * @taskNames.length)]
#      @tasks.push
#        'startDate': d3.time.hour.offset(lastEndDate, Math.ceil(1 * Math.random()))
#        'endDate': d3.time.hour.offset(lastEndDate, Math.ceil(Math.random() * 3) + 1)
#        'taskName': taskName
#        'status': taskStatusName
#      @changeTimeDomain @timeDomainString
#      @gantt.redraw @tasks
#      return
#
#    removeTask: ->
#      @tasks.pop()
#      @changeTimeDomain @timeDomainString
#      @gantt.redraw @tasks
#      return