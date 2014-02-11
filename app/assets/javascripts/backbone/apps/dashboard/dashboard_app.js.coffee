@Learnster.module "DashApp", (DashApp, App, Backbone, Marionette, $, _) ->

  App.vent.on "clicked:add:course", (org) ->
    orgId = org.id
    App.navigate "/organisation/#{orgId}/courses"

  App.vent.on "clicked:add:module", (org) ->
    orgId = org.id
    App.navigate "/organisation/#{orgId}/modules"

  App.vent.on "dash:block:clicked", (model, org) ->
    App.vent.trigger("course:clicked", model) if model instanceof App.Entities.Course
    App.vent.trigger("module:clicked", model) if model instanceof App.Entities.LearningModule


