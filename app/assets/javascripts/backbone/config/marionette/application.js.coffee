do (Backbone, $) ->

	_.extend Backbone.Marionette.Application::,

		navigate: (route, options = {}) ->
			# cannot nav to login when logged in
			route = @rootRoute  if (route.indexOf("login") is not -1 and @rootRoute is not "/login")
			route = "#" + route if route.charAt(0) is "/"

			options["trigger"] = true
			Backbone.history.navigate route, options

		getCurrentRoute: ->
			frag = Backbone.history.fragment
			if _.isEmpty(frag) then null else frag

		startHistory: ->
			if Backbone.history
				Backbone.history.start()
				$(document).on 'click', 'a:not([data-bypass])', (e) ->
					href = $(this).attr 'href'
					protocol = this.protocol + '//'
					if href.slice(protocol.length) is not protocol
						e.preventDefault()
						@navigate @rootRoute,
									trigger: true


		register: (instance, id) ->
			@_registry ?= {}
			@_registry[id] = instance

		unregister: (instance, id) ->
			delete @_registry[id]

		resetRegistry: ->
			oldCount = @getRegistrySize()
			for k, controller of @_registry
				controller.region.close()
			msg = "There were #{oldCount} controllers in the _registry, there are now #{@getRegistrySize()}"
			if @getRegistrySize() > 0 then console.warn(msg, @_registry) else console.log(msg)

		getRegistrySize: ->
			_.size @_registry


		makeToast: (options = {}) ->
			$("<div>").toaster
							position:
								top: 110, right: 0
			$("<div>#{options.text}</div>").toast
												type: options.type


