path   = require "path"
config = require path.join __dirname, "../../", "config.json"

exports.init = (app)->
  app.get "/admin", (req, res, next)->
    res.locals.config.scripts = config.jade.admin_scripts
    # res.render (if (req.session.admin) then "admin/index" else "admin/guest"), res.locals
    res.render "admin/index", res.locals
    