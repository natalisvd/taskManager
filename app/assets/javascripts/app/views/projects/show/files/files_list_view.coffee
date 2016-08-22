define [
  'chaplin'
  'app/base/collection_view'
  'text!app/views/projects/show/files/files_list.hbs'
  'app/views/projects/show/files/file_item_view'
], (Ch, CollectionView, template, FileItemView) ->
  'use strict'

  class FilesListView extends CollectionView

    itemView: FileItemView
    template: template
    autoRender: true
    className: 'files-list-view'
    listSelector: '.list'

    events:
      'click .upload-file-btn': 'uploadFile'

    afterRender: ->
      @$('.upload-file').change (evt) =>
        @handleFileSelect(evt.target.files)
        evt.target.value = ''

    uploadFile: ->
      @$('.upload-file').click()

    handleFileSelect: (files) ->
      i = 0
      while files[i]
        file_obj = files[i]
        @collection.newFile(file_obj)
        i += 1