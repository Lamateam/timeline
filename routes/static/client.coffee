path   = require "path"
config = path.join __dirname, "../../", "config.json"

exports.init = (app)->
  app.get "/client", (req, res, next)->
    res.locals.config.scripts = config.jade.client_scripts
    # res.render (if (req.session.user) then "client/index" else "client/guest"), res.locals
    res.render "client/index", res.locals