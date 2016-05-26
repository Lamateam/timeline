exports.init = (app)->
  app.get "/", (req, res, next)->
    res.redirect "/client"
    