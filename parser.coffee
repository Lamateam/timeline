request = require "request"
config  = require "./config.json"
$       = require "cheerio"
fs      = require "fs"

class Parser 
  options:
    url: config.parser.https.url
    path: config.parser.https.path
  constructor: (@title, @data=[])->
    console.log "Ready to parse " + @title
    @parse()
  prefix: ($el)->
    prefix = ""
    prev = $el.prev()

    while (prev.get(0) isnt undefined) and (prev.get(0).tagName isnt "h2")
      prev = prev.prev()

    if prev.get(0) isnt undefined
      t = prev.find(".mw-headline").text().toLowerCase()
      if t is "родились"
        prefix = "Родился "
      else if (t is "скончались") or (t is "умерли")
        prefix = "Умер "
      else if t is "нобелевские премии"
        prefix = "Нобелевская премия "

    return prefix    
  parse: ()->
    request @options.url + @options.path + @title, @onRequest.bind(@)
  onRequest: (error, response, body)->
    if error
      console.error "Something went wrong in parser.coffee! " + error
    else
      @parseContainer $(body).find("#mw-content-text")

      fs.writeFile "./bd/"+@title+".json", JSON.stringify({data: @data}, null, 2)
  parseContainer: (container)->
    container.children("div, p").remove()
    container.children("ul").each @parseUl.bind(@)
  parseUl: (i, ul)->
    $el = $(ul)
    if $el.attr("class") is undefined
      prefix = @prefix $el
      $el.find("li").each (i, li)=>
        @parseLi i, li, prefix
  parseLi: (i, li, prefix)->
    text = $(li).text().replace(/\[(.*)\]/gi, "").replace(/\((.*)\)/gi, "")
    if prefix is "Нобелевская премия "
      text = text.replace(/\—/gi, "получена").replace(/^Литература/gi, "по литературе").replace(/^Физика/gi, "по физике").replace(/^Химия/gi, "по химии").replace(/^Медицина\sи\sфизиология/gi, "по медицине и физиологии").replace(/^Экономика/gi, "по экономике").replace(/^Премия мира/gi, "мира")
    @data.push prefix + text

exports.parse = (title)->
  new Parser title
  # options = 
  #   url: config.parser.https.url
  #   path: config.parser.https.path + title

  # request options.url + options.path, (error, response, body)->
  #   res = 
  #     data: []
  #   b = $(body).find("#mw-content-text")
  #   b.children("div, p").remove()
  #   b.children("ul").each (i, el)->
  #     $el = $(el)
  #     if $el.attr("class") is undefined
  #       prefix = getPrefix($el)
  #       $el.find("li").each (j, li)->
  #         text = $(li).text().replace(/\[(.*)\]/gi, "").replace(/\((.*)\)/gi, "")
  #         if prefix is "Нобелевская премия "
  #           text = text.replace(/\—/gi, "получена").replace(/^Литература/gi, "по литературе").replace(/^Физика/gi, "по физике").replace(/^Химия/gi, "по химии").replace(/^Медицина\sи\sфизиология/gi, "по медицине и физиологии").replace(/^Экономика/gi, "по экономике").replace(/^Премия мира/gi, "мира")
  #         res.data.push prefix + text

  #   # console.log res
  #   fs.writeFile "./bd/"+title+".json", JSON.stringify(res, null, 2)
