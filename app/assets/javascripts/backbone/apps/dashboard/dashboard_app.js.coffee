@Learnster.module "DashApp", (DashApp, App, Backbone, Marionette, $, _) ->

  App.vent.on "clicked:add:course", (org) ->
    orgId = org.id
    App.navigate "/organisation/#{orgId}/courses"

  App.vent.on "clicked:add:module", (org) ->
    orgId = org.id
    App.navigate "/organisation/#{orgId}/modules"


