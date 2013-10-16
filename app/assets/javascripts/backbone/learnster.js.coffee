@Learnster = do ($, Backbone, Marionette) ->

	App = new Marionette.Application()


	App.on "initialize:before", (options) ->
		App.environment = options.environment
		if not _.isEmpty(gon)
			userType = gon.type[0].toLowerCase() + gon.type.slice(1)
			App.currentUser = App.reqres.request "init:current:#{userType}", gon
		else
		   App.currentUser = false


	App.reqres.setHandler "get:current:user", ->
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

	App.addInitializer ->
		App.module("HeaderApp").start()
		App.module("SidebarApp").start()
		App.module("FooterApp").start()


	App.commands.setHandler "unregister:instance", (instance, id) ->
		App.unregister instance, id if App.environment is "development"

	App.commands.setHandler "register:instance", (instance, id) ->
		App.register instance, id if App.environment is "development"

	App.commands.setHandler "set:root:route", =>
		App.rootRoute = "/students"      if App.currentUser instanceof Learnster.Entities.Student
		App.rootRoute = "/org_admins" 	 if App.currentUser instanceof Learnster.Entities.OrgAdmin
		App.rootRoute = "/organisations" if App.currentUser instanceof Learnster.Entities.AppAdmin
		App.rootRoute = "/login" 		 if Object(App.currentUser) instanceof Boolean

	App.commands.setHandler "redirect:home", =>
		App.execute "set:root:route"
		App.navigate(App.rootRoute)

	App.on "initialize:after", ->
			$().UItoTop({ easingType: 'easeOutQuart' }) #move to executed command

			App.execute "set:root:route"
			@startHistory()
			if @getCurrentRoute() and not Object(App.currentUser) instanceof Boolean
				@navigate(@getCurrentRoute())
			else
				App.execute "redirect:home"

	App