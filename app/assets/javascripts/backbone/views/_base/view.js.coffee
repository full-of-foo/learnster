@Learnster.module "Views", (Views, App, Backbone, Marionette, $, _, Routes) ->

	_remove = Marionette.View::remove

	_.extend Marionette.View::,

		addOpacityWrapper: (init = true) ->
			@$el.toggleWrapper
				className: "opacity"
			, init

		setInstancePropertiesFor: (args...) ->
			for key, val of _.pick(@options, args...)
				@[key] = val


		remove: (args...) ->
			# console.log "removing", @

			if @model?.isDestroyed?()
				wrapper = @$el.toggleWrapper
					className: "opacity"
					backgroundColor: "red"

				wrapper.fadeOut 400, ->
					$(@).remove()

				@$el.fadeOut 400, =>
					_remove.apply @, args
			else
				_remove.apply @, args


		templateHelpers: ->

			route: (route_name, params = []) ->
				if params.length > 0 then Routes[route_name](params[0]) else Routes[route_name]()

			capitalizeTitle: (title) ->
				if title
					(title.split(/[ ]|[-]/).map (word) -> word[0].toUpperCase() + word[1..-1].toLowerCase()).join ' '
				else
					""

			dockerItemElement: (elemId, imageName, caption) ->
				"<li id='#{@escape(elemId)}' class='dock-item'><img src='/images/#{@escape(imageName)}' /><span>#{@escape(caption)}</span></li>"

			currentUser: ->
				user = App.reqres.request("get:current:user")
				if Object(user) not instanceof Boolean
					user.toJSON()
				else
					false

			isCreatedByUser: (created_by) ->
				user = App.reqres.request("get:current:user")
				if Object(user) not instanceof Boolean
					created_by.id is user.get('id') or user instanceof App.Entities.AppAdmin
				else
					false

			editOrShowField: (id, value, isField, editType = "text") ->
				if isField
					"<input type='#{@escape(editType)}' id='#{@escape(id)}' value='#{@escape(value)}'/>"
				else
					"<span id='#{@escape(id)}'>#{@escape(value)}</span>"

			linkTo: (name, url, options = {}) ->
				options.external = false unless options.external

				url = "#" + url unless options.external
				"<a href='#{url}'>#{@escape(name)}</a>"

, Routes
