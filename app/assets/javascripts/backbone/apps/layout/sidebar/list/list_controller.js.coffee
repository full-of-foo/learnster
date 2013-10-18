@Learnster.module "SidebarApp.List", (List, App, Backbone, Marionette, $, _) ->

	class List.Controller extends App.Controllers.Base

		initialize: (options) ->
			switch options.type
				when "AppAdmin" then sideBarItems = @getAppAdminBarItems()
				when "OrgAdmin" then sideBarItems = @getOrgAdminBarItems()
				when "Student" then sideBarItems = 	@getStudentBarItems()
				when "Login" then sideBarItems = 	@getLoginBarItems()

			sideItemCollection = App.request "sidebar:entities", sideBarItems
			sideBarView = 		 App.request "tree:wrapper", sideItemCollection

			@show sideBarView

		getAppAdminBarItems: ->
			[
				{ text: "Students",      	 default:  true },
				{ text: "Org Admins"      },
				{ text: "Organisations"   }
			]

		getOrgAdminBarItems: ->
			[
				{ text: "Org Students",      default:  true },
				{ text: "My Students" },
				{ text: "Org Admins"  },
				{ text: "My Admins"   }
			]

		getStudentBarItems: ->
			[
				{ text: "Course mates",          default:  true },
				{ text: "Educators" },
				{ text: "Modules"  }
			]

		getLoginBarItems: ->
			[
				{ text: "Sign in",           default:  true },
				{ text: "Sign up Organisation" }
			]




