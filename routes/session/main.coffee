exports.init = (app)->
  require("./language.coffee").init app
  require("./login.coffee").init app
  require("./logout.coffee").init app
  require("./handshaking.coffee").init app

    