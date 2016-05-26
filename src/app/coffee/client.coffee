$(document).ready ()->
  
  #Needed global functions#

  ###JQuery WOW.js extention start###

  new WOW().init()

  ###JQuery Knob extention start###

  $(".knob").knob()

  ###Login functions###

  $(".login_form_btn").on "click", ()->
    if $("#login").val() is ""
      return sweetAlert(window.language.global.error, window.language.enter.nologin, "error")
    if $("#password").val() is ""
      return sweetAlert(window.language.global.error, window.language.enter.nopassword, "error")

    JCapi("/api/login", "POST",
      login: $("#login").val()
      password: $("#password").val()
    )(()->
      location.reload();
    )(()->
      sweetAlert(window.language.global.error, window.language.enter.error, "error")
    )
    
  $(".header_logout").on "click", ()->
    JCapi("/api/logout", "POST")(()->
      location.reload();
    )
