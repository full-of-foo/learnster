@Learnster.module "CourseSectionsApp.New", (New, App, Backbone, Marionette, $, _) ->

  class New.Controller extends App.Controllers.Base

    initialize: (options = {}) ->
      @_nestingOrgId = options.region?._nestingOrgId
      @_nestingCourseId = options.courseId

      courseSection = App.request "new:course_section:entity"
      courseSection.set('course_id', @_nestingCourseId)
      
      @layout = @getLayoutView courseSection

      @listenTo courseSection, "created", ->
        App.vent.trigger "course_section:created", courseSection

      @listenTo @layout, "show", =>
        @setFormRegion courseSection

      @show @layout

    getLayoutView: (courseSection) ->
      new New.Layout
        model: courseSection

    getNewView: (courseSection) ->
      new New.Section
        model: courseSection

    setFormRegion: (courseSection) ->
      @newView = @getNewView courseSection
      formView = App.request "form:wrapper", @newView

      @listenTo formView, "show", ->
        @setProvisionerSelector(formView)

      @listenTo @newView, "form:cancel", =>
        @region.close()

      @show formView,
        loading:
            loadingType: "spinner"
        region:  @layout.formRegion

    setProvisionerSelector: (newLayout) ->
      orgId = @_nestingOrgId
      admins = App.request("org_admin:from:role:entities", orgId, "course_manager")
      selectView = App.request "selects:wrapper",
        collection: admins
        itemViewId: "provisioned_by"
        itemView:   App.Components.Selects.UserOption

      @show selectView,
        loading:
            loadingType: "spinner"
        region:  @newView.provisionerSelectRegion