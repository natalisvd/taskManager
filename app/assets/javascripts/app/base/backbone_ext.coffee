define ->
  'use strict'

  #Smarter JSON, we overwrite sync to keep rails convention of having a root
  #to requests.
  !do (Backbone) ->
    #store the old sync, this is to make testing easier.
    Backbone.oldSync = Backbone.sync
    #replace backbone sync with our own version.

    Backbone.sync = (method, model, options) ->
    #pass in a includeParamRoot = true to the options
      if options.data is undefined and model and (method == 'create' or method == 'update' or method == 'patch')
        options.includeParamRoot = true
      Backbone.oldSync.apply this, [
        method
        model
        options
      ]

    _.extend Backbone.Model.prototype,
      toJSON: (options) ->
        data = {}
        attrs = _.clone(@attributes)
        #if the model has a paramRoot attribute, use it as the root element
        if options and options.includeParamRoot and @paramRoot
          data[@paramRoot] = attrs
        else
          data = attrs
        data
    return