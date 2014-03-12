@Learnster.module "SettingsApp", (SettingsApp, App, Backbone, Marionette, $, _, TogetherJS) ->

  App.vent.on "user:updated user:cancelled", (user) ->
    TogetherJS.refreshUserData()
    orgId = if user.get('type') is "OrgAdmin" then user.get('admin_for').id else user.get('attending_org').id
    App.navigate "/organisation/#{orgId}/dashboard"

, TogetherJS
