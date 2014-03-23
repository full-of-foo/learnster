do (Backbone) ->
	_sync = Backbone.sync

	Backbone.sync = (method, entity, options = {}) ->

		_.defaults options,
			beforeSend: 	_.bind(methods.beforeSend, 	      entity)
			complete:		_.bind(methods.complete, entity, options)

		sync = _sync(method, entity, options)
		if((!entity._fetch and method is "read") or (options.is_sign_in and method is "create"))
			entity._fetch = sync

	methods =
		beforeSend: ->
			@trigger "sync:start", @

		complete: (options) ->
			@trigger("synced:pagninable:collection", @,  options
				.xhr.getResponseHeader('Link')) if options
					.xhr.getResponseHeader('Link')

			if options.xhr.status is 401
				@trigger "unpermitted:entity", @
			if options.xhr.status is 404
				@trigger "not:found:entity", @
			@trigger "sync:stop", @
