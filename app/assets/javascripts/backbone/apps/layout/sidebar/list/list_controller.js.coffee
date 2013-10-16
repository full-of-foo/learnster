@Learnster.module "SidebarApp.List", (List, App, Backbone, Marionette, $, _) ->

	class List.Controller extends App.Controllers.Base

		initialize: (options) ->
			@initOrgAdminBar(options) if options.type is "OrgAdmin"
			@initAppAdminBar(options) if options.type is "AppAdmin"

		initOrgAdminBar: (options) =>
			sideBarItems = @getOrgAdminBarItems()

		initAppAdminBar: (options) =>
			sideBarItems = @getAppAdminBarItems()
			sideItemCollection = App.request "sidebar:entities", sideBarItems

			sideBarView = App.request "sidebar:wrapper", sideItemCollection
			@show sideBarView

		getAppAdminBarItems: ->
			[
				{ text: "Application Admin", isHeader: true },
				{ text: "Students",      default:  true },
				{ text: "Org Admins"      },
				{ text: "Organisations"   }
			]

		getOrgAdminBarItems: ->
			[
				{ text: "Organisation Admin", isHeader: true },
				{ text: "Org Students",      default:  true },
				{ text: "My Students" },
				{ text: "Org Admins"  },
				{ text: "My Admins"   }
			]


	App.reqres.setHandler "sidebar:wrapper", (collection) ->
		throw new Error "No sidebar collection supplied" unless collection
		new List.SideBar
				collection: collection

