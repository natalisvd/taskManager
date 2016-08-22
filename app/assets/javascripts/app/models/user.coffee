define [
  'app/base/model'
], (Model) ->
  'use strict'

  class User extends Model
    url: '/api/c_user'

    signedIn: ->
      !$.isEmptyObject(@getAttributes())

    logout: ->
      $.get
        url: '/users/sign_out'
        success: =>
          location.reload()

    matchId: (id) ->
      @get('id') is id