do (Backbone) ->
	_sync = Backbone.sync

	Backbone.sync = (method, entity, options = {}) ->
		
		_.defaults options,
			beforeSend: 	_.bind(methods.beforeSend, 	entity)
			complete:		_.bind(methods.complete, entity, options)

		sync = _sync(method, entity, options)
		if !entity._fetch and method is "read"
			entity._fetch = sync

		
	
	methods =
		beforeSend: ->
			@trigger "sync:start", @
		
		complete: (options) ->
			if options.xhr.status is 401 
				Backbone.history.navigate "/login", { trigger: true }		
			@trigger "sync:stop", @