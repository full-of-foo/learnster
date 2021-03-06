@Learnster.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.DockItem extends Entities.Models

  class Entities.DockItemCollection extends Entities.Collections
    model: Entities.DockItem

  API =
    getAppAdminDockerCollection: ->
      new Entities.DockItemCollection(@getAppAdminArr())

    getOrgAdminDockerCollection: ->
      new Entities.DockItemCollection(@getOrgAdminArr())

    getStudentDockerCollection: ->
      new Entities.DockItemCollection(@getStudentArr())

    getLoginDockerCollection: ->
      new Entities.DockItemCollection(@getLoginArr())

    getAppAdminArr: ->
      [
        { elemId: "home-dock-item", imageName: "home256.png", caption: "Home" },
        { elemId: "notifications-dock-item", imageName: "announcements256.png", caption: "Notifications" },
        { elemId: "stats-dock-item", imageName: "skill-gap256.png", caption: "App Statistics" },
      ]

    getOrgAdminArr: ->
      [
        { elemId: "home-dock-item", imageName: "home256.png", caption: "Home" },
        { elemId: "notifications-dock-item", imageName: "announcements256.png", caption: "Notifications" },
        { elemId: "stats-dock-item", imageName: "skill-gap256.png", caption: "Statistics" },
        { elemId: "collaborate-dock-item", imageName: "Teachers256.png", caption: "Collaborate" },
        { elemId: "profile-settings-dock-item", imageName: "maintenance256.png",   caption: "Profile Setting" }
      ]

    getStudentArr: ->
      [
        { elemId: "home-dock-item", imageName: "home256.png", caption: "Home" },
        { elemId: "notifications-dock-item", imageName: "announcements256.png", caption: "Notifications" },
        { elemId: "collaborate-dock-item", imageName: "Teachers256.png", caption: "Collaborate" },
        { elemId: "profile-settings-dock-item", imageName: "maintenance256.png",   caption: "Profile Setting" }
      ]

    getLoginArr: ->
      [
        { elemId: "about-dock-item", imageName: "lessons256.png", caption: "About" },
        { elemId: "testimonials-dock-item", imageName: "Teachers256.png", caption: "Testimonials" },
        { elemId: "join-dock-item", imageName: "wizard256.png", caption: "How to Join" }
      ]

  App.reqres.setHandler "AppAdmin:docker:entities", ->
    API.getAppAdminDockerCollection()

  App.reqres.setHandler "OrgAdmin:docker:entities", ->
    API.getOrgAdminDockerCollection()

  App.reqres.setHandler "Student:docker:entities", ->
    API.getStudentDockerCollection()

  App.reqres.setHandler "Login:docker:entities", ->
    API.getLoginDockerCollection()
