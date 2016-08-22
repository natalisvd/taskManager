define [
  'chaplin'
  'app/models/user'
  'app/models/users'
], (Ch, User, Users) ->
  'use strict'

  m = Ch.mediator

  m.user = new User()
  window.p = m.projects = null
  window.u = m.users = new Users()

  Ch.m = m