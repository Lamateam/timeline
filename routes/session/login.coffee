exports.init = (app)->
  app.post "/api/session/login", (req, res, next)->
    if (req.body.login isnt undefined) and (req.body.password isnt undefined)
      app.get('connector').users().login req.body.login, req.body.password, (err, user)->
        if err 
          res.send {"!err": err}
        else
          token = req.sessionID
          app.get('connector').sessions().create {user_id: user.id, token: token}, (err, session)->
            res.send if err then {"!err": err} else {"token": token}
    else
      res.send {"!err": "005"}