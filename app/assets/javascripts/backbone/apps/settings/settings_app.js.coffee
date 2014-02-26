@Learnster.module "SettingsApp", (SettingsApp, App, Backbone, Marionette, $, _) ->

  App.vent.on "user:updated user:cancelled", (user) ->
    orgId = if user.get('type') is "OrgAdmin" then user.get('admin_for').id else user.get('attending_org').id
    App.navigate "/organisation/#{orgId}/dashboard"
