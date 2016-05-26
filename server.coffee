express      = require 'express'
session      = require 'express-session'
YAML         = require 'yamljs'
body_parser  = require 'body-parser'

connector    = require './schemas/main.coffee'

config       = require "./config.json"

app = express()

# jade config
app.set "views", "src/views"
app.set 'view engine', 'jade'

# session
app.use session config.session

# static
app.use "/static", express.static("dist")

# set locale pack
language_packages = {}
for lang in config.languages 
  language_packages[lang] = YAML.load "src/language/" + lang + "/main.yml"

app.use (req, res, next)->
  res.locals.config = config.jade
  req.session.lang = "russian" if req.session.lang is undefined

  lang = req.session.lang
  res.locals.language = language_packages[lang]
  res.locals.language_string = JSON.stringify(language_packages[lang])

  next()

# bodyparser for json
app.use body_parser.json({ type: 'application/json' })

# database
app.set "connector", new connector(config.connector)

# routes
require("./routes/main.coffee").init app

app.listen config.port, ()->
  console.log 'App listening on port 3000!'

# parser = require "./parser.coffee"
# getHandlerParse = (i)->
#   return ()->
#     parser.parse i+"_год"

# for i in [1..2001]
#   setTimeout getHandlerParse(i), i*400
