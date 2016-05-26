knex  = require 'knex'

Users    = require "./users.coffee"
Sessions = require "./sessions.coffee"

class Knex
  constructor: (config)->
    @knex = knex config
    @schemas = 
      users: new Users @knex
      sessions: new Sessions @knex
  users: ->
    @schemas.users
  sessions: ->
    @schemas.sessions

module.exports = Knex