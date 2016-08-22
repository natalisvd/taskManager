define [
  'chaplin'
  'app/base/collection'
  'app/models/user'
], (Ch, Collection, User) ->
  'use strict'

  class Users extends Collection

    model: User
#    url: -> "/api/projects/#{@project_id}/users"

    initialize: (models, options) ->
#      @project_id = options.project_id
      super