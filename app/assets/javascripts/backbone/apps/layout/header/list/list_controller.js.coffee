@Learnster.module "HeaderApp.List", (List, App, Backbone, Marionette, $, _) ->

    class List.Controller extends App.Controllers.Base

        initialize: (options) ->
            links = App.request "header:entities"

            headerView = @getHeaderView(links)
            @show headerView


        getHeaderView: (links) ->
            new List.Headers
                # collection:links
