exports.init = (app)->
  app.post "/api/session/logout", (req, res, next)->
    if req.body.token isnt undefined
      app.get('connector').sessions().offline {token: req.body.token}, (err, session)->
        res.send if err then {"!err": err} else {ok: "ok"}
    else
      res.send {"!err": "005"}