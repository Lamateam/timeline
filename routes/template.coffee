path = require "path"
fs   = require "fs"

exports.init = (app)->
  app.get "/api/template", (req, res, next)->
    if req.query.id isnt undefined
      id       = "template/" + req.query.id.replace /\_\_/gi, "/"
      tpl_path = path.join __dirname, "../", "src/views/" + id + ".jade"

      fs.access tpl_path, fs.F_OK, (err)->
        if err then res.send {"!err": "004"} else app.render id, res.locals, (err, html)->
          res.send if err then {"!err": "006"} else {"html": html}
    else
      res.send {"!err": "005"}