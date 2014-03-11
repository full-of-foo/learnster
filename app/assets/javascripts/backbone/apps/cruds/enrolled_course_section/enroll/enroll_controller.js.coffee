@Learnster.module "EnrolledCourseSectionsApp.Enroll", (Enroll, App, Backbone, Marionette, $, _) ->

  class Enroll.Controller extends App.Controllers.Base

    initialize: (options = {}) ->
      @_nestingOrgId = options.region?._nestingOrgId
      @_nestingCourseSectionId = options.region?._nestingCourseSectionId

      enrollment = App.request "new:enrolled:course:section:entity"
      enrollment.set("course_section_id",  @_nestingCourseSectionId )


      @layout = @getLayoutView enrollment

      @listenTo enrollment, "created", ->
        @region.close()
        App.vent.trigger "enrollment:created", enrollment

      @listenTo @layout, "show", =>
        @setFormRegion enrollment

      @show @layout

    getLayoutView: (enrollment) ->
      new Enroll.Layout
        model: enrollment

    getNewView: (enrollment) ->
      new Enroll.Student
        model: enrollment

    setFormRegion: (enrollment) ->
      @newView = @getNewView enrollment
      formView = App.request "form:wrapper", @newView,
        toast:
          message: "student enrolled"

      @listenTo formView, "show", ->
        @setStudentSelector(formView)

      @listenTo @newView, "form:cancel", =>
        @region.close()

      @show formView,
        loading:
            loadingType: "spinner"
        region:  @layout.formRegion

    setStudentSelector: (newLayout) ->
      orgId = @_nestingOrgId
      students = App.request("org:student:entities", orgId)
      selectView = App.request "selects:wrapper",
        collection: students
        itemViewId: "student_id"
        itemView:   App.Components.Selects.UserOption

      @show selectView,
        loading:
            loadingType: "spinner"
        region:  @newView.studentSelectRegion
