window.Learnster =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  initialize: ->
    new Learnster.Routers.Users()
    Backbone.history.start()

$(document).ready ->
  Learnster.initialize()
