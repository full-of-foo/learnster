@Learnster.module "CourseSectionsApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  class Show.Layout extends App.Views.Layout
    template: "course_sections/show/templates/show_layout"
    regions:
      courseSectionRegion: "#course-section-region"
      modulesRegion:       "#list-module-region"
      addModuleRegion:     "#add-module-region"
      modulePanelRegion:   "#module-panel-region"


  class Show.CourseSection extends App.Views.ItemView
    template: "course_sections/show/templates/show_course_section"
    triggers:
      "click #edit-course-section-button"   : "edit:course_section:button:clicked"
      "click #delete-course-section-button" : "delete:course_section:button:clicked"

  class Show.DeleteDialog extends App.Views.ItemView
    template: 'course_sections/show/templates/delete_dialog'
    tagName: 'div'
    className: 'modal fade'
    triggers:
      "click #delete-course-section-button" : "dialog:delete:course_section:clicked"

    onShow: ->
      @$el.modal()

  class Show.Panel extends App.Views.ItemView
    template: 'course_sections/show/templates/panel'
    triggers:
      "click #new-course-section-button" : "new:course:section:button:clicked"
