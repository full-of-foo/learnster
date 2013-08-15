@Learnster.module "Views", (Views, App, Backbone, Marionette, $, _) ->

    _.extend Marionette.View::,

        templateHelpers: ->

            # currentUser:
            #     App.request("get:current:user").toJSON()


            linkTo: (name, url, options = {}) ->
                options.external = false unless options.external

                url = "#" + url unless options.external
                "<a href='#{url}'>#{@escape(name)}</a>"
