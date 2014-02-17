@Learnster.module "EnrolledCourseSectionsApp.Remove", (Remove, App, Backbone, Marionette, $, _) ->

  class Remove.Layout extends App.Views.Layout
    template: "enrolled_course_section/remove/templates/remove_layout"
    regions:
      formRegion: "#form-region"

  class Remove.Student extends App.Views.Layout
    template: "enrolled_course_section/remove/templates/remove_student"
    regions:
      studentSelectRegion: "#student-select-region"
    triggers:
      "click .cancel-remove-student" : "form:cancel"
      "click #remove-student-button" : "remove:student:submitted"
