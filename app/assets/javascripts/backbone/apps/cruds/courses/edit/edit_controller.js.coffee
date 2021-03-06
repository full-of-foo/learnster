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
      @editView = @getEditView course
      
      @listenTo @editView, "form:cancel", ->
        App.vent.trigger "course:cancelled", course

      formView = App.request "form:wrapper", @editView,
        toast:
          message: "#{course.get('title')} updated"

      @listenTo formView, "show", ->
        @setManagerSelector(formView, course)

      @listenTo @editView, "notice:icon:clicked", ->
        $('.notice-icon').popover()

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

    setManagerSelector: (newLayout, course) ->
      orgId        = App.currentUser.get('admin_for').id
      defaultEmail = course.get('managed_by').email
      admins       = App.request("org_admin:from:role:entities", orgId, "course_manager")
      
      selectView = App.request "selects:wrapper",
        collection: admins
        itemViewId: "managed_by"
        itemView:   App.Components.Selects.UserOption

      @listenTo selectView, "show", ->
        _.delay(( => $('.selectpicker').
                selectpicker('val', defaultEmail)) , 400)

      @show selectView,
        loading:
            loadingType: "spinner"
        region:  @editView.managerSelectRegion
