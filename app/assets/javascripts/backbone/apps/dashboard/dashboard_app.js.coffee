@Learnster.module "DashApp", (DashApp, App, Backbone, Marionette, $, _) ->

  App.vent.on "clicked:add:course", (org) ->
    console.log "yayyyy"
    orgId = org.id
    App.navigate "/organisation/#{orgId}/courses"
