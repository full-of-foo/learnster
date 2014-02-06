@Learnster.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.DashBlock extends Entities.Models

  API =
    getBlockEntity: (title) ->
      new Entities.DashBlock
        title: title
        allText: "See all #{title}..."


  App.reqres.setHandler "dash:block:entity", (title) ->
    API.getBlockEntity title
