define [
  'chaplin'
  'app/base/model'
], (Ch, Model) ->
  'use strict'

  class File extends Model

    url: ->
      "/api/#{@collection.source}/#{@collection.source_obj.get('id')}/upload_file"

    save: (attrs, options) ->
      formData = new FormData()
      formData.append('attach_file[path]', @get('file'))
      $.ajax
        type: 'POST'
        url: @url()
        data: formData
        cache: false
        contentType: false
        processData: false
        success: (response) =>
          if response.success
            @clear()
            @set(response.attach_file)
          else
            @collection.remove(@)
            @dispose()
        error: =>
          @collection.remove(@)
          @dispose()