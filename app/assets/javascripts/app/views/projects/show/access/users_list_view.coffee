define [
  'chaplin'
  'app/base/collection_view'
  'app/views/projects/show/access/user_item_view'
], (Ch, CollectionView, UserItemView) ->
  'use strict'

  class UsersListView extends CollectionView

    itemView: UserItemView
    autoRender: true
    className: 'list-group users-list-view'
    tagName: 'ul'

    initialize: ->
      @collection = Ch.m.users
      super

    filterer: (user, index) ->
      user.get('access_to_project') isnt 'creator'