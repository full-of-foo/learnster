@Learnster = do ($, Backbone, Marionette) ->

  App = new Marionette.Application()


  App.on "initialize:before", (options) ->
    App.environment = options.environment
    if not _.isEmpty(gon)
      userType = gon.type[0].toLowerCase() + gon.type.slice(1)
      App.currentUser = App.reqres.request("init:current:#{userType}", gon)
    else if $.cookie('user_id') and $.cookie('user_type')
      App.currentUser = App.reqres.request("fetch:current:user", $.cookie('user_id'), $.cookie('user_type'))
      App.commands.execute("when:fetched", App.currentUser, ->  App.commands.execute("reset:regionstonav", App.getCurrentRoute()))
    else
      App.currentUser = false


  App.reqres.setHandler "get:current:user", ->
    App.currentUser

  App.reqres.setHandler "fetch:current:user", (id, type) ->
    switch type
      when "AppAdmin" then App.currentUser = App.request("appAdmin:entity", id)
      when "OrgAdmin" then App.currentUser = App.request("orgAdmin:entity", id)
      when "Student"  then App.currentUser = App.request("student:entity", id)
      else throw new Error "Attributes supplied do not have correct user type"
    App.currentUser

  App.reqres.setHandler "set:current:user", (attrs) ->
    switch attrs.type
      when "AppAdmin" then App.currentUser = App.request("init:current:appAdmin", attrs)
      when "OrgAdmin" then App.currentUser = App.request("init:current:orgAdmin", attrs)
      when "Student"  then App.currentUser = App.request("init:current:student", attrs)
      else throw new Error "Attributes supplied do not have correct user type"
    App.currentUser

  App.reqres.setHandler "default:region", ->
    App.mainRegion

  App.addRegions
    headerRegion:  "#header-region"
    sidebarRegion: "#sidebar-region"
    mainRegion:    "#main-region"
    footerRegion:  "#footer-region"
    dialogRegion:  Marionette.Region.Dialog.extend el:"#dialog-region"

  App.addInitializer ->
    App.module("HeaderApp").start()
    App.module("SidebarApp").start()
    App.module("FooterApp").start()


  App.commands.setHandler "unregister:instance", (instance, id) ->
    App.unregister instance, id if App.environment is "development"

  App.commands.setHandler "register:instance", (instance, id) ->
    App.register instance, id if App.environment is "development"

  App.commands.setHandler "set:root:route", =>
    if App.currentUser instanceof Learnster.Entities.Student
      orgId = App.currentUser.get('attending_org').id
      App.rootRoute = "/organisation/#{orgId}/students"

    else if App.currentUser instanceof Learnster.Entities.OrgAdmin
      orgId = App.currentUser.get('admin_for').id
      App.rootRoute = "/organisation/#{orgId}/students"

    App.rootRoute = "/organisations"  if App.currentUser     instanceof Learnster.Entities.AppAdmin
    App.rootRoute = "/login"          if Object(App.currentUser) instanceof Boolean

  App.commands.setHandler "redirect:home", =>
    App.execute "set:root:route"
    App.navigate(App.rootRoute)

  App.commands.setHandler "refresh:current:route", ->
    App.refreshCurrentRoute()

  App.commands.setHandler "reset:regions", ->
    App.execute "set:root:route"
    App.execute "show:sidebar"
    App.execute "show:header"
    App.execute "redirect:home"

  App.commands.setHandler "reset:regionstonav", (route) ->
    App.execute "set:root:route"
    App.execute "show:sidebar"
    App.execute "show:header"
    App.navigate(route)

  App.on "initialize:after", ->
      App.execute "set:root:route"
      App.startHistory()
      if App.getCurrentRoute() isnt null and Object(App.currentUser) not instanceof Boolean
        App.navigate(App.getCurrentRoute())
      else
        App.execute "redirect:home"

  App