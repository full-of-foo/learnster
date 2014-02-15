@Learnster.module "StaticApp", (StaticApp, App, Backbone, Marionette, $, _) ->

  class StaticApp.Router extends App.Routers.AppRouter
    appRoutes:
      "about"        : "showAbout"
      "testimonials" : "showTestimonials"

  API =
    showAbout: ->
      new StaticApp.Show.Controller
        type: "about"

    showTestimonials: ->
      new StaticApp.Show.Controller
        type: "testimonials"

  App.addInitializer ->
    new StaticApp.Router
      controller: API
