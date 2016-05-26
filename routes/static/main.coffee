exports.init = (app)->
  require("./admin.coffee").init app
  require("./index.coffee").init app
  require("./client.coffee").init app

    