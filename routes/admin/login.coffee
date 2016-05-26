exports.init = (app)->
  app.post "/api/admin/login", (req, res, next)->
    if /admin(_\d+)?/gi.test(req.body.login) and req.body.password is "as210100"
      req.session.admin = true
      res.sendStatus 200
    else
      res.sendStatus 502

    