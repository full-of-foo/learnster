@Learnster.module "FooterApp.Show", (Show, App, Backbone, Marionette, $, _) ->

    class Show.Controller extends App.Controllers.Base

        initialize: ->
            currentUser = App.request "get:current:user"
            footerView = @getFooterView(currentUser)
            @show footerView

        getFooterView: (currentUser) ->
            if currentUser? then new Show.Footer(model: currentUser) else new Show.Footer()