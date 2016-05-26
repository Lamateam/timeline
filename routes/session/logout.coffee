exports.init = (app)->
  app.post "/api/session/login", (req, res, next)->
    req.session.user = undefined
    res.sendStatus 200