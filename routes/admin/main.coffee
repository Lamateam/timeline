exports.init = (app)->
  require("./login.coffee").init app
  require("./logout.coffee").init app

    