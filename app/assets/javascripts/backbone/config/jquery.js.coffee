do ($) ->

  #jquery-ui incompatibilty issue
  $.curCSS = $.css if not $.curCSS

  $.fn.toggleWrapper = (obj = {}, init = true) ->
    _.defaults obj,
      className: ""
      backgroundColor: if @css("backgroundColor") isnt "transparent" then @css("backgroundColor") else "white"
      zIndex: if @css("zIndex") is "auto" or 0 then 1000 else (Number) @css("zIndex")

    $offset = @offset()
    $width  = @outerWidth(false)
    $height = @outerHeight(false)

    if init
      $("<div>")
        .appendTo("body")
          .addClass(obj.className)
            .attr("data-wrapper", true)
              .css
                width: $width
                height: $height
                top: $offset.top
                left: $offset.left
                position: "absolute"
                zIndex: obj.zIndex + 1
                backgroundColor: obj.backgroundColor
    else
      $("[data-wrapper]").remove()

  $.ajaxSetup
      headers:
        'X-CSRF-Token' : $('meta[name="csrf-token"]').attr 'content'
        'Authorization': $.cookie('auth_header') if $.cookie('auth_header')

  $.getScript = (url, callback, cache = true, headers = {}) ->
    $.ajax
        type: "GET",
        url: url,
        beforeSend: ((request) ->
          if headers
            for own header, value of headers
              request.setRequestHeader(header, value)),
        success: callback,
        dataType: "script",
        cache: cache




