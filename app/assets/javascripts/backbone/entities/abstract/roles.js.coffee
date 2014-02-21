@Learnster.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.Role extends Entities.Models

  class Entities.RoleCollection extends Entities.Collections
    model: Entities.Role

  API =
    getRoles: ->
      rolesArr = [
        { elemId: "role", camelValue: "account_manager", value: "Account Manager" },
        { elemId: "role", camelValue: "course_manager", value: "Course Manager" },
        { elemId: "role", camelValue: "module_manager", value: "Module Manager" },
      ]
      new Entities.RoleCollection(rolesArr)

  App.reqres.setHandler "role:entities", ->
    API.getRoles()
