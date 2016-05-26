exports.init = (app)->
  app.post "/api/session/language", (req, res, next)->
    req.session.lang = req.body.language
    res.sendStatus 200

  app.get "/api/session/language", (req, res, next)->
    langs = [ "russian", "english" ]
    result = []

    result.push {id: l, is_checked: l is req.session.lang} for l in langs

    res.send {"languages": result}

    