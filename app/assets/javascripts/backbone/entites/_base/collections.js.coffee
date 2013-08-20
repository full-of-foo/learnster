@Learnster.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

    class Entities.Collections extends Backbone.Collection

        fetch: (options = {}) ->
            # options.reset = true
            super options
