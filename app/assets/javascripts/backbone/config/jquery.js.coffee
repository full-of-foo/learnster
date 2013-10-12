do ($) ->
	$.fn.toggleWrapper = (obj = {}, init = true) ->
		console.log "toggling?"
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
			console.log "removing wrapper?"
			$("[data-wrapper]").remove()

	$.ajaxSetup
			headers:
				'X-CSRF-Token': $('meta[name="csrf-token"]').attr 'content'



