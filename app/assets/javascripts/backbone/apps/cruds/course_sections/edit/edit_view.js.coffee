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


  class Edit.CourseSection extends App.Views.Layout
    template: "course_sections/edit/templates/edit_course_section"
    regions:
      provisionerSelectRegion: "#provisioner-select-region"
    modelEvents:
      "sync:after": "render"

    onShow: ->
      _.delay(( =>
              options =
                content:   "<ul>
                              <li>allows for the chaging of this section's provisioner</li>
                              <li>both account and course managers can be a \"section provisioner\"</li>
                            </ul>"
                html:      true
                placement: 'left'

              $('.notice-icon').popover(options)
        ), 400)

    triggers:
      "click .notice-icon" : "notice:icon:clicked"

