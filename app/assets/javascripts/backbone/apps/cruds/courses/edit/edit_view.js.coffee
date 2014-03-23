@Learnster.module "CoursesApp.Edit", (Edit, App, Backbone, Marionette, $, _) ->

  class Edit.Layout extends App.Views.Layout
    template: "courses/edit/templates/edit_layout"
    className: "container-fluid row-fluid"
    regions:
      titleRegion:  "#title-region"
      formRegion:   "#form-region"


  class Edit.Title extends App.Views.ItemView
    template: "courses/edit/templates/edit_title"
    modelEvents:
      "updated": "render"


  class Edit.Course extends App.Views.ItemView
    template: "courses/edit/templates/edit_course"
    modelEvents:
      "sync:after": "render"
