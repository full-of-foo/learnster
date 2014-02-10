@Learnster.module "CourseSectionsApp.New", (New, App, Backbone, Marionette, $, _) ->

  class New.Layout extends App.Views.Layout
    template: "course_sections/new/templates/new_layout"
    regions:
      formRegion: "#form-region"


  class New.Section extends App.Views.Layout
    template: "course_sections/new/templates/new_section"
    regions:
      provisionerSelectRegion: "#provisioner-select-region"

    triggers:
      "click .cancel-new-course-section" : "form:cancel"

    form:
      buttons:
        primary:    "Add Section"
        primaryClass: "btn btn-primary"
