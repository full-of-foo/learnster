@Learnster.module "CoursesApp.New", (New, App, Backbone, Marionette, $, _) ->

  class New.Layout extends App.Views.Layout
    template: "courses/new/templates/new_layout"
    regions:
      formRegion: "#form-region"


  class New.View extends App.Views.Layout
    template: "courses/new/templates/new_course"
    regions:
      managerSelectRegion: "#manager-select-region"

    onShow: -> 
      _.delay(( => 
              options = 
                content:   "<ul>
                              <li>allows the managing of this course's sections/terms, student enrollments and module module enrollments</li>
                              <li>any account and course managers can be this 'course's manager'</li>
                              <li>any account managers can later change this manager</li>
                            </ul>"
                html:      true
                placement: 'left' 
                title:     "Managing a course:"

              $('.notice-icon').popover(options)
        ), 400)

    triggers:
      "click .cancel-new-course" : "form:cancel"
      "click .notice-icon"       : "notice:icon:clicked"

    form:
      buttons:
        primary:    "Add Course"
        primaryClass: "btn btn-primary"
