@Learnster.module "CoursesApp.Edit", (Edit, App, Backbone, Marionette, $, _) ->

  class Edit.Controller extends App.Controllers.Base

    initialize: (options) ->
      id = options.id
      course = App.request "course:entity", id

      @listenTo course, "updated", ->
        App.vent.trigger "course:updated", course

      @layout = @getLayoutView course
      @listenTo @layout, "show", =>
        @setTitleRegion course
        @setFormRegion course

      @show @layout

    getLayoutView: (course) ->
      new Edit.Layout
        model: course

    getEditView: (course) ->
      new Edit.Course
        model: course

    getTitleView: (course) ->
      new Edit.Title
        model: course

    setFormRegion: (course) ->
      editView = @getEditView course
      @listenTo editView, "form:cancel", ->
        App.vent.trigger "course:cancelled", course

      formView = App.request "form:wrapper", editView,
        toast:
          message: "#{course.get('title')} updated"

      @show formView,
        loading:
          loadingType: "spinner"
        region:  @layout.formRegion


    setTitleRegion: (course) ->
      titleView = @getTitleView course
      @show titleView,
        loading:
          loadingType: "spinner"
        region:  @layout.titleRegion
