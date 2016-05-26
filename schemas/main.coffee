knex  = require 'knex'

Users = require "./users.coffee"

class Knex
  constructor: (config)->
    @knex = knex config
    @schemas = 
      users: new Users @knex
  users: ->
    @schemas.users

module.exports = Knex