@Learnster.module "CoursesApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  class Show.Layout extends App.Views.Layout
    template: "courses/show/templates/show_layout"
    regions:
      courseRegion:             "#show-course-region"
      courseSectionsRegion:     "#list-course-section-region"
      courseSectionPanelRegion: "#course-section-panel-region"


  class Show.Course extends App.Views.ItemView
    template: "courses/show/templates/show_course"
    triggers:
      "click #edit-course-button" : "edit:course:button:clicked"
      "click #delete-course-button" : "delete:course:button:clicked"

  class Show.DeleteDialog extends App.Views.ItemView
    template: 'courses/list/templates/delete_dialog'
    tagName: 'div'
    className: 'modal fade'
    triggers:
      "click #delete-course-button" : "dialog:delete:course:clicked"

    onShow: ->
      @$el.modal()

  class Show.Panel extends App.Views.ItemView
    template: 'courses/show/templates/panel'
