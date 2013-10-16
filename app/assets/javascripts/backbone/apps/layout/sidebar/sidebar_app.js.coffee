@Learnster.module "SidebarApp", (SidebarApp, App, Backbone, Marionette, $, _) ->
	@startWithParent = false

	API =
		listOrgAdminSidebar: ->
			new SidebarApp.List.Controller
								type: "OrgAdmin"
								region: App.sidebarRegion

		listAppAdminSidebar: ->
			new SidebarApp.List.Controller
								type: "AppAdmin"
								region: App.sidebarRegion

	SidebarApp.on "start", ->
		user = App.request "get:current:user"
		if user instanceof Learnster.Entities.AppAdmin
			API.listAppAdminSidebar()
		else if user instanceof Learnster.Entities.OrgAdmin
			API.listOrgAdminSidebar()

