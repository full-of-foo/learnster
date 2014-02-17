@Learnster.module "CourseSectionsApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  class Show.Layout extends App.Views.Layout
    template: "course_sections/show/templates/show_layout"
    regions:
      courseSectionRegion: "#course-section-region"
      listRegion:          "#list-region"
      addRegion:           "#add-region"
      panelRegion:         "#panel-region"
    triggers:
      "click #modules-tab"  : "modules:tab:clicked"
      "click #students-tab" : "students:tab:clicked"


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
      "click #add-module-button"    : "add:module:button:clicked"
      "click #remove-module-button" : "remove:module:button:clicked"

  class Show.StudentPanel extends App.Views.ItemView
    template: 'course_sections/show/templates/student_panel'
    triggers:
      "click #add-student-button"    : "add:student:button:clicked"
      "click #remove-student-button" : "remove:student:button:clicked"
