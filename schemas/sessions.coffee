AbstractSchema = require './abstract.coffee'

class SessionsSchema extends AbstractSchema
  name: "sessions"
  initTable: (table, callback)->
    table.integer("user_id")
    table.string("status").defaultTo("online").collate "utf8_general_ci"
    table.string("token").unique().collate "utf8_general_ci"

    callback()
  get: (filter, callback)->
    @knex.select('*').from('sessions').where(filter).whereNot({status: "offline"}).then((rows)=>
      callback null, (if rows.length is 0 then null else rows[0])
    ).catch (err)->
      console.log err
      callback "008", null
  create: (data, callback)->
    @knex.transaction((trx)=>
      @knex.transacting(trx).select('*').from('sessions').where({user_id: data.user_id}).then((rows)=>
        if rows.length is 0
          data.created_at = @knex.fn.now()
          data.updated_at = @knex.fn.now()
          @knex("sessions").transacting(trx).insert(data).then(trx.commit).catch trx.rollback
        else
          row = rows[0]

          row.status     = "online"
          row.token      = data.token
          row.updated_at = @knex.fn.now()

          @knex("sessions").transacting(trx).where({user_id: data.user_id}).update(row).then(trx.commit).catch trx.rollback
      ).catch trx.rollback
    ).then((resp)->
      callback null, resp
    ).catch (err)->
      callback "007", null
  offline: (data, callback)->
    @knex.transaction((trx)=>
      @knex.transacting(trx).select('*').from('sessions').where(data).whereNot({status: "offline"}).then((rows)=>
        if rows.length is 0
          callback("003", null)
          trx.rollback()
        else
          @knex("sessions").transacting(trx).where(data).update({status: "offline"}).then(trx.commit).catch trx.rollback
      ).catch trx.rollback
    ).then((resp)->
      callback null, resp
    ).catch (err)->
      callback("009", null) if err


module.exports = SessionsSchema