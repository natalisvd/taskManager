define [
  'chaplin'
  'app/base/collection_view'
  'text!app/views/projects/projects_list.hbs'
  'app/views/projects/project_item_view'
], (Ch, CollectionView, template, ProjectItemView) ->
  'use strict'

  class ProjectsListView extends CollectionView

    itemView: ProjectItemView
    template: template
    autoRender: true
    container: '.projects-bar'
    className: 'projects-list-view'
    listSelector: '.list'

    events:
      'click .new-proj': 'createProject'

    createProject: ->
      @collection.newProject()

    render: ->
      $('body').css('background-image', 'none') #TODO fix
      super