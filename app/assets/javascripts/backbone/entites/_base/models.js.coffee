@Learnster.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

    class Entities.Models extends Backbone.RelationalModel

        initialize: ->
            @on "all", (e) -> console.log e if App.enviornment is "development"

        fetch: (options = {}) ->
            # options.reset = true
            super options

        destroy: (options = {}) ->
            _.defaults options,
                wait: true

            @set _destroy: true
            super options

        isDestroyed: ->
            @get "_destroy"

        save: (data, options = {}) ->
            isNew = @isNew()
            
            _.defaults options,
                wait: true
                success:    _.bind(@saveSuccess, @, isNew, options.collection)
                error:      _.bind(@saveError, @)
            
            @unset "_errors"
            super data, options
        
        saveSuccess: (isNew, collection) =>
            if isNew ## model is being created
                collection.add @ if collection
                collection.trigger "model:created", @ if collection
                @trigger "created", @
            else ## model is being updated
                collection ?= @collection ## if model has collection property defined, use that if no collection option exists
                collection.trigger "model:updated", @ if collection
                @trigger "updated", @
        
        saveError: (model, xhr, options) =>
            console.warn xhr, model
            ## set errors directly on the model unless status returned was 500 or 404
            @set _errors: $.parseJSON(xhr.responseText)?.errors unless xhr.status is 500 or xhr.status is 404