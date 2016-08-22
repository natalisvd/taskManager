define [
  'chaplin'
], (Chaplin) ->
  'use strict'

  class Collection extends Chaplin.Collection
    _.extend @prototype, Chaplin.SyncMachine
