@Learnster.module "OrgAdminsApp.Edit", (Edit, App, Backbone, Marionette, $, _) ->

  class Edit.Layout extends App.Views.Layout
    template: "org_admins/edit/templates/edit_layout"
    regions:
      titleRegion:  "#title-region"
      formRegion:   "#form-region"


  class Edit.Title extends App.Views.ItemView
    template: "org_admins/edit/templates/edit_title"

    modelEvents:
      "updated": "render"


  class Edit.OrgAdmin extends App.Views.Layout
    template: "org_admins/edit/templates/edit_org_admin"

    modelEvents:
      "sync:after": "render"

    regions:
      roleSelectRegion: "#role-select-region"
