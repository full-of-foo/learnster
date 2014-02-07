@Learnster.module "CoursesApp.New", (New, App, Backbone, Marionette, $, _) ->

  class New.Layout extends App.Views.Layout
    template: "courses/new/templates/new_layout"
    regions:
      formRegion: "#form-region"


  class New.View extends App.Views.ItemView
    template: "courses/new/templates/new_course"
    triggers:
      "click .cancel-new-course" : "form:cancel"

    form:
      buttons:
        primary:    "Add Course"
        primaryClass: "btn btn-primary"
