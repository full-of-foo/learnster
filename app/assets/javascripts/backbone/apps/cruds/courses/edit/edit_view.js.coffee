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


  class Edit.Course extends App.Views.Layout
    template: "courses/edit/templates/edit_course"
    regions:
      managerSelectRegion: "#manager-select-region"
    modelEvents:
      "sync:after": "render"

    onShow: ->
      _.delay(( =>
              options =
                content:   "<ul>
                              <li>allows for the changing of this courses's manager</li>
                              <li>any account and course manager can be this \"course's manager\"</li>
                            </ul>"
                html:      true
                placement: 'left'

              $('.notice-icon').popover(options)
        ), 400)

    triggers:
      "click .notice-icon" : "notice:icon:clicked"
