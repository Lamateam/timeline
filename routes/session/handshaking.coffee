exports.init = (app)->
  app.get "/api/session/handshaking", (req, res, next)->
    res.send {port: 3000}