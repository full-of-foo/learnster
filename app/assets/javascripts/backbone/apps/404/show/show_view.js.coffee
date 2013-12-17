@Learnster.module "NotFoundApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  class Show.NotFoundPage extends App.Views.ItemView
    template: '404/show/templates/404'
