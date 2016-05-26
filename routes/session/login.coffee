exports.init = (app)->
  app.post "/api/session/login", (req, res, next)->
    if (req.body.login isnt undefined) and (req.body.password isnt undefined)
      app.get('connector').users().login req.body.login, req.body.password, (err, user)->
        if err 
          res.send {"!err": err}
        else
          req.session.user = user
          res.sendStatus 200
    else
      res.send {"!err": "005"}