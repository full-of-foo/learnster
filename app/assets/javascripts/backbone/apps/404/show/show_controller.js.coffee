@Learnster.module "NotFoundApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  class Show.Controller extends App.Controllers.Base

    initialize: ->
      @show(new Show.NotFoundPage())

    renderNotFound: ->
      console.log "to render not found"

