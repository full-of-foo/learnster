@Learnster.module "EnrolledCourseSectionsApp.Enroll", (Enroll, App, Backbone, Marionette, $, _) ->

  class Enroll.Layout extends App.Views.Layout
    template: "enrolled_course_section/enroll/templates/enroll_layout"
    regions:
      formRegion: "#form-region"

  class Enroll.Student extends App.Views.Layout
    template: "enrolled_course_section/enroll/templates/enroll_student"
    regions:
      studentSelectRegion: "#student-select-region"
    triggers:
      "click .cancel-enroll-student"      : "form:cancel"
      "click span#remove-student-button"  : "remove:student:submitted"

    form:
      buttons:
        primary:    "Add Student"
        primaryClass: "btn btn-primary"
