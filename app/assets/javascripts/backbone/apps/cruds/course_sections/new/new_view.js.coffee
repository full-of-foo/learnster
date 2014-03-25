@Learnster.module "CourseSectionsApp.New", (New, App, Backbone, Marionette, $, _) ->

  class New.Layout extends App.Views.Layout
    template: "course_sections/new/templates/new_layout"
    regions:
      formRegion: "#form-region"


  class New.Section extends App.Views.Layout
    template: "course_sections/new/templates/new_section"
    regions:
      provisionerSelectRegion: "#provisioner-select-region"

    onShow: -> 
      _.delay(( => 
              options = 
                content:   "<ul>
                              <li>along with the manager of this course, provisioners can manage this section's student
                               enrollments and module enrollments</li>
                              <li>both account and course managers can be a 'section provisioner'</li>
                              <li>along with the manager of this course, any account manager can later change this provisioner</li>
                            </ul>"
                html:      true
                placement: 'left' 
                title:     "Provisioning a course:"

              $('.notice-icon').popover(options)
        ), 400)

    triggers:
      "click .cancel-new-course-section" : "form:cancel"
      "click .notice-icon"               : "notice:icon:clicked"

    form:
      buttons:
        primary:    "Add Section"
        primaryClass: "btn btn-primary"
