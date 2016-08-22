define [
  'chaplin'
  'app/base/view'
  'text!app/views/navbar/navbar.hbs'
], (Ch, View, template) ->
  'use strict'

  class NavbarView extends View

    template: template
    autoRender: true
    container: 'body'
    containerMethod: 'prepend'
    className: 'navbar-view navbar navbar-default'
    tagName: 'nav'

    initialize: ->
      @delegate 'click', '.logout', Ch.m.user.logout

    getTemplateData: ->
      data = Ch.m.user.getAttributes()
      data.signed_in = Ch.m.user.signedIn()
      data