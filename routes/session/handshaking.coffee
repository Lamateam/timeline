exports.init = (app)->
  app.get "/api/session/handshaking", (req, res, next)->
    app.get('connector').sessions().get {status: "online", token: req.sessionID}, (err, session)->
      res.send if err then {"!err": err} else (if session is null then {port: 3000} else {port: 3000, token: session.token})