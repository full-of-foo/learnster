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

	App.reqres.setHandler "default:region", ->
		App.mainRegion

	App.addRegions
		headerRegion:  "#header-region"
		sidebarRegion: "#sidebar-region"
		mainRegion:    "#main-region"
		footerRegion:  "#footer-region"

	App.addInitializer ->
		App.module("HeaderApp").start()
		App.module("SideBarApp").start()
		App.module("FooterApp").start()


	App.commands.setHandler "unregister:instance", (instance, id) ->
		App.unregister instance, id if App.environment is "development"

	App.commands.setHandler "register:instance", (instance, id) ->
		App.register instance, id if App.environment is "development"

	App.commands.setHandler "redirect:home", =>
		App.navigate(App.rootRoute)

	App.on "initialize:after", ->
			$().UItoTop({ easingType: 'easeOutQuart' }) #move to executed command
			@rootRoute = if App.request("get:current:user") then "/students" else "/login"
			@startHistory()

			if @getCurrentRoute() and @getCurrentRoute is not "/login"
				@navigate(@getCurrentRoute())
			else
				App.execute "redirect:home"

	App