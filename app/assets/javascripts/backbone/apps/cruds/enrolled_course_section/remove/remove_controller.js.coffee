@Learnster.module "EnrolledCourseSectionsApp.Remove", (Remove, App, Backbone, Marionette, $, _) ->

  class Remove.Controller extends App.Controllers.Base

    initialize: (options = {}) ->
      @_nestingOrgId = options.region?._nestingOrgId
      @_nestingCourseSectionId = options.region?._nestingCourseSectionId
      enrollment = App.request "new:enrolled:course:section:entity"
      @layout = @getLayoutView enrollment

      @listenTo @layout, "show", =>
        @setFormRegion enrollment

      @show @layout

    getLayoutView: (enrollment) ->
      new Remove.Layout
        model: enrollment

    getNewView: (enrollment) ->
      new Remove.Student
        model: enrollment

    setFormRegion: (enrollment) ->
      @newView = @getNewView enrollment

      @listenTo @newView, "show", ->
        @setStudentSelector(@newView)

      @listenTo @newView, "remove:student:submitted", (view) ->
        dropDownValue = $("#remove-student .filter-option").text().trim()
        studentId = $("select option:contains('#{dropDownValue}')").attr('data-id')
        enrollment.set("id", 0) # hack
        enrollment.set("student_id", studentId)
        enrollment.set("course_section_id",  @_nestingCourseSectionId)

        enrollment.destroy
          data: $.param
            course_section_id: @_nestingCourseSectionId
            student_id: studentId

        enrollment.on "destroy", => App.vent.trigger "enrollment:removed", enrollment

      @listenTo @newView, "form:cancel", =>
        @region.close()

      @show @newView,
        loading:
            loadingType: "spinner"
        region:  @layout.formRegion

    setStudentSelector: (newLayout) ->
      orgId = @_nestingOrgId
      students = App.request("section:student:entities", @_nestingCourseSectionId)
      selectView = App.request "selects:wrapper",
        collection: students
        itemViewId: "student_id"
        itemView:   App.Components.Selects.UserOption

      @show selectView,
        loading:
            loadingType: "spinner"
        region:  @newView.studentSelectRegion
