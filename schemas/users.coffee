crypto         = require 'crypto'

AbstractSchema = require './abstract.coffee'

class UsersSchema extends AbstractSchema
  name: "users"
  initTable: (table, callback)->
    table.string("login").unique().collate "utf8_general_ci"
    table.string("password").collate "utf8_general_ci"
    table.string("description").collate "utf8_general_ci"
    table.string("status").defaultTo("player").collate "utf8_general_ci"
    table.string("salt").collate "utf8_general_ci"

    callback()
  register: (data, callback)->
    data.salt     = Math.round((new Date().valueOf() * Math.random())) + ''
    data.password = crypto.createHmac('sha1', data.salt).update(data.password).digest 'hex'

    @knex("users").insert(data).then(callback).catch (err)->
      console.error "Error in Users schema! Method 'register':\n", err
  login: (login, password, callback)->
    @knex.select('*').from('users').where({login: login}).then((rows)->
      if rows.length isnt 0
        user = rows[0]
        if user.password is crypto.createHmac('sha1', user.salt).update(password).digest 'hex'
          callback null, user
        else
          callback "001", null
      else
        callback "002", null
    ).catch (err)->
      console.error "Error in Users schema! Method 'login':\n", err


module.exports = UsersSchema