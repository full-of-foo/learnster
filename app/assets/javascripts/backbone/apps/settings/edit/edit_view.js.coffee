@Learnster.module "SettingsApp.Edit", (Edit, App, Backbone, Marionette, $, _) ->

  class Edit.Layout extends App.Views.Layout
    template: "settings/edit/templates/edit_layout"
    regions:
      titleRegion:  "#title-region"
      formRegion:   "#form-region"


  class Edit.Title extends App.Views.ItemView
    template: "settings/edit/templates/edit_title"
    modelEvents:
      "updated": "render"


  class Edit.User extends App.Views.Layout
    template: "settings/edit/templates/edit_user"

    modelEvents:
      "sync:after": "render"

    regions:
      roleSelectRegion: "#role-select-region"
