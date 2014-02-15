@Learnster.module "StaticApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  class Show.Controller extends App.Controllers.Base

    initialize: (options = {}) ->
      viewType = options.type
      @layout = @getLayoutView()

      @listenTo @layout, "show", ->
        switch viewType
          when "about" then @showAbout()
          when "testimonials" then @showTestimonials()

      @show @layout
      App.commands.execute "clear:sidebar:higlight"

    showAbout: ->
      aboutView = @getAboutView()
      @layout.staticRegion.show aboutView

    showTestimonials: ->
      testimonialsView = @getTestimonialsView()
      @layout.staticRegion.show testimonialsView

    getTestimonialsView: ->
      new Show.Testimonials()

    getAboutView: ->
      new Show.About()

    getLayoutView: ->
      new Show.Layout()
