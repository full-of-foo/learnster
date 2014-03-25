@Learnster.module "LearningModulesApp.Edit", (Edit, App, Backbone, Marionette, $, _) ->

  class Edit.Layout extends App.Views.Layout
    template: "learning_modules/edit/templates/edit_layout"
    className: "container-fluid row-fluid"
    regions:
      titleRegion:  "#title-region"
      formRegion:   "#form-region"


  class Edit.Title extends App.Views.ItemView
    template: "learning_modules/edit/templates/edit_title"
    modelEvents:
      "updated": "render"


  class Edit.Module extends App.Views.Layout
    template: "learning_modules/edit/templates/edit_module"
    regions:
      educatorSelectRegion: "#educator-select-region"

    onShow: -> 
      _.delay(( => 
              options = 
                content:   "<ul>
                              <li>allows for the changing of this module's educator/teacher</li>
                              <li>all manager account holders can be a module 'educator'</li>
                            </ul>"
                html:      true
                placement: 'left' 

              $('.notice-icon').popover(options)
        ), 400)

    modelEvents:
      "sync:after": "render"
    triggers:
      "click .notice-icon" : "notice:icon:clicked"
