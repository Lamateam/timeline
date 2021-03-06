$(document).ready ()->
  
  # Needed global functions #

  ### JQuery WOW.js extention start ###

  new WOW().init()

  ### JQuery Knob extention start ###

  $(".knob").knob()

  ### Login functions ###

  $(".login_form_btn").on "click", ()->
    if $("#login").val() is ""
      return sweetAlert(window.language.global.error, window.language.enter.nologin, "error")
    if $("#password").val() is ""
      return sweetAlert(window.language.global.error, window.language.enter.nopassword, "error")

    JCapi("/api/session/login", "POST",
      login: $("#login").val()
      password: $("#password").val()
    )(()->
      location.reload();
    )(()->
      sweetAlert(window.language.global.error, window.language.enter.error, "error")
    )
    
  $(".header_logout").on "click", ()->
    JCapi("/api/session/logout", "POST")(()->
      location.reload()
    )

  ### Cards classes ###

  class Card
    container: $("#cards_place")
    constructor: (@card)->
      @render @card
    render: (card)->
      @el = $("<li><img src='" + card.src + "' /><h1>" + card.year + "</h1><i>" + card.description + "</i></li>").appendTo @container

  $(".get_cards").on "click", ()->
    JCapi("/api/admin/cards")((cards)->
      new Card(c) for c in cards
    )