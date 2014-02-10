@Learnster.module "CourseSectionsApp.Edit", (Edit, App, Backbone, Marionette, $, _) ->

  class Edit.Controller extends App.Controllers.Base

    initialize: (options) ->
      id = options.id
      courseSection = App.request "course_section:entity", id

      @listenTo courseSection, "updated", ->
        App.vent.trigger "course_section:updated", courseSection

      @layout = @getLayoutView courseSection
      @listenTo @layout, "show", =>
        @setTitleRegion courseSection
        @setFormRegion courseSection

      @show @layout

    getLayoutView: (courseSection) ->
      new Edit.Layout
        model: courseSection

    getEditView: (courseSection) ->
      new Edit.CourseSection
        model: courseSection

    getTitleView: (courseSection) ->
      new Edit.Title
        model: courseSection

    setFormRegion: (courseSection) ->
      editView = @getEditView courseSection
      @listenTo editView, "form:cancel", ->
        App.vent.trigger "course_section:cancelled", courseSection

      formView = App.request "form:wrapper", editView
      @show formView,
        loading:
          loadingType: "spinner"
        region:  @layout.formRegion


    setTitleRegion: (courseSection) ->
      titleView = @getTitleView courseSection
      @show titleView,
        loading:
          loadingType: "spinner"
        region:  @layout.titleRegion
