exports.init = (app)->
  app.post "/api/admin/login", (req, res, next)->
    req.session.admin = false
    res.sendStatus 200