class AbstractSchema
  isIncrements: true
  isTimestamps: true
  constructor: (@knex)->
    console.log @name + " schema creating!"

    @pull    = []
    @isReady = false

    @knex.schema.hasTable(@name).then (exists)=>
      if exists then @ready() else @knex.schema.createTable @name, (table)=>
        table.timestamps() if @isTimestamps
        table.increments() if @isIncrements
        @initTable table, @ready.bind(@)

  ready: ->
    console.log @name + " schema ready!"
    @isReady = true
    fn() for fn in @pull
  onReady: (fn)->
    if @isReady then fn() else @pull.push(fn)
  initTable: (table, callback)->
    console.log @name + " doesn't implement initTable method!"
    callback()

module.exports = AbstractSchema