@Learnster.module "OrgAdminsApp", (OrgAdminsApp, App, Backbone, Marionette, $, _) ->

  class OrgAdminsApp.Router extends App.Routers.AppRouter
    appRoutes:
      "org_admin/:id/edit"    : "edit"
      "admins"                : "listOrgAdmins"


  API =
    listOrgAdmins: ->
      new OrgAdminsApp.List.Controller()

    newOrgAdmin: (region) ->
      new OrgAdminsApp.New.Controller
        region: region

    edit: (id) ->
      new OrgAdminsApp.Edit.Controller
        id: @get_org_admin_id(id)

    get_org_admin_id: (id_org_admin) ->
      id = if id_org_admin.id then id_org_admin.id else id_org_admin

    openImportDialog: (organisation) ->
      new OrgAdminsApp.Import.Controller
        region: App.dialogRegion
        model: organisation


  App.commands.setHandler "new:org_admin:view", (region) ->
    API.newOrgAdmin(region)

  App.vent.on "org_admin:clicked org_admin:created", (id) ->
    App.navigate Routes.edit_api_org_admin_path(id).split("/api")[1]

  App.vent.on "org_admin:cancelled org_admin:updated", (org_admin) ->
    App.goBack()

  App.vent.on "open:admin:import:dialog", (organisation) ->
    API.openImportDialog organisation



  App.addInitializer ->
    new OrgAdminsApp.Router
      controller: API
