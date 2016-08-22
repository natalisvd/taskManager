define [
  'chaplin'
  'app/base/view'
  'text!app/views/projects/projects.hbs'
], (Ch, View, template) ->
  'use strict'

  class ProjectsView extends View

    container: 'body'
    template: template
    autoRender: true
    className: 'container-fluid projects-view'