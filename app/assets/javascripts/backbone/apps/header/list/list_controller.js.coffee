@Learnster.module "HeaderApp.List", (List, App, Backbone, Marionette, $, _) ->

    List.Controller =

        listHeader: ->
            links = App.request "header:entities"
            console.log links

            headerView = @getHeaderView(links)
            App.headerRegion.show headerView


        getHeaderView: (links) ->
            new List.Headers
                collection:links
