@Learnster.module "CoursesApp.New", (New, App, Backbone, Marionette, $, _) ->

  class New.Controller extends App.Controllers.Base

    initialize: (options = {}) ->
      @_nestingOrg = options.region?._nestingOrg

      course  = App.request "new:course:entity"
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
      @newView = @getNewView course
      formView = App.request "form:wrapper", @newView,
        toast:
          message: "course created"

      @listenTo formView, "show", ->
        @setManagerSelector(formView)

      @listenTo @newView, "form:cancel", =>
        @region.close()

      @listenTo @newView, "notice:icon:clicked", ->
        $('.notice-icon').popover()

      @layout.formRegion.show formView

    setManagerSelector: (newLayout) ->
      user  = App.currentUser
      orgId = App.currentUser.get('admin_for').id

      admins = App.request("org_admin:from:role:entities", orgId, "course_manager")
      selectView = App.request "selects:wrapper",
        collection: admins
        itemViewId: "managed_by"
        itemView:   App.Components.Selects.UserOption

      @listenTo selectView, "show", ->
        _.delay(( => $('.selectpicker').
                selectpicker('val', user.get('email'))) , 400)

      @show selectView,
        loading:
            loadingType: "spinner"
        region:  @newView.managerSelectRegion
