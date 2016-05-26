exports.init = (app)->
  require("./admin/main.coffee").init app
  require("./session/main.coffee").init app
  require("./static/main.coffee").init app
  require("./template.coffee").init app

    