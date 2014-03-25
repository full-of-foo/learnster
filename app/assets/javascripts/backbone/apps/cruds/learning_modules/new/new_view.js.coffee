@Learnster.module "LearningModulesApp.New", (New, App, Backbone, Marionette, $, _) ->

  class New.Layout extends App.Views.Layout
    template: "learning_modules/new/templates/new_layout"
    regions:
      formRegion: "#form-region"


  class New.Module extends App.Views.Layout
    template: "learning_modules/new/templates/new_module"
    regions:
      educatorSelectRegion: "#educator-select-region"

    onShow: -> 
      _.delay(( => 
              options = 
                content:   "<ul>
                              <li>along with the manager of the course and provisioners of the section, the educator can manage this 
                              module's supplements/lessons, contents and deliverables</li>
                              <li>all manager account holders can be a module 'educator'</li>
                              <li>this educator, along with the manager of the course and provisioners of the section, can later change 
                              this educator</li>
                            </ul>"
                html:      true
                placement: 'left' 
                title:     "Educating a module:"

              $('.notice-icon').popover(options)
        ), 400)

    triggers:
      "click .cancel-new-module" : "form:cancel"
      "click .notice-icon"       : "notice:icon:clicked"

    form:
      buttons:
        primary:    "Create Module"
        primaryClass: "btn btn-primary"
