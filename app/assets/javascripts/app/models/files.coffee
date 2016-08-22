define [
  'chaplin'
  'app/base/collection'
  'app/models/file'
], (Ch, Collection, File) ->
  'use strict'

  class Files extends Collection

    model: File
    source: null #projects/tasks/comments
    source_obj: null
#    url: '/api/files'

    initialize: (models, options) ->
      @source = options.source
      @source_obj = options.source_obj
      super

    newFile: (file_obj) ->
      attrs = {file: file_obj, new: true}
      file = new File(attrs)
      @add(file)
      file.save()