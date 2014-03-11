@Learnster.module "CoursesApp.New", (New, App, Backbone, Marionette, $, _) ->

  class New.Controller extends App.Controllers.Base

    initialize: (options = {}) ->
      @_nestingOrg = options.region?._nestingOrg

      course = App.request "new:course:entity"
      @layout = @getLayoutView course

      @listenTo course, "created", ->
        App.vent.trigger "course:created", course

      @listenTo @layout, "show", =>
        @setFormRegion course

      @show @layout

    getLayoutView: (course) ->
      new New.Layout
        model: course

    getNewView: (course) ->
      new New.View
        model: course

    setFormRegion: (course) ->
      newView = @getNewView course
      formView = App.request "form:wrapper", newView,
        toast:
          message: "course created"

      @listenTo newView, "form:cancel", =>
        @region.close()

      @layout.formRegion.show formView
