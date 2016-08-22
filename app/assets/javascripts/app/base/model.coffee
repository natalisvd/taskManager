define [
  'chaplin'
], (Chaplin) ->
  'use strict'

  class Model extends Chaplin.Model
    _.extend @prototype, Chaplin.SyncMachine