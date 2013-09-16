@Learnster.module "Views", (Views, App, Backbone, Marionette, $, _) ->

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
            console.log "removing", @
            
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

            # currentUser:
            #     App.request("get:current:user").toJSON()


            linkTo: (name, url, options = {}) ->
                options.external = false unless options.external

                url = "#" + url unless options.external
                "<a href='#{url}'>#{@escape(name)}</a>"
