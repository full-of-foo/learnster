@Learnster.module "CourseSectionsApp.Edit", (Edit, App, Backbone, Marionette, $, _) ->

  class Edit.Layout extends App.Views.Layout
    template: "course_sections/edit/templates/edit_layout"
    className: "container-fluid row-fluid"
    regions:
      titleRegion:  "#title-region"
      formRegion:   "#form-region"


  class Edit.Title extends App.Views.ItemView
    template: "course_sections/edit/templates/edit_title"
    modelEvents:
      "updated": "render"


  class Edit.CourseSection extends App.Views.ItemView
    template: "course_sections/edit/templates/edit_course_section"
    modelEvents:
      "sync:after": "render"
