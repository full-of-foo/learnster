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
				{ imageName: "home256.png",          caption: "Home" },
				{ imageName: "announcements256.png", caption: "Notifications" },
				{ imageName: "skill-gap256.png",     caption: "App Statistics" },
				{ imageName: "maintenance256.png",   caption: "Profile Setting" }
			]

		getOrgAdminArr: ->
			[
				{ imageName: "home256.png",          caption: "Home" },
				{ imageName: "announcements256.png", caption: "Notifications" },
				{ imageName: "skill-gap256.png",     caption: "Statistics" },
				{ imageName: "maintenance256.png",   caption: "Profile Setting" }
			]

		getStudentArr: ->
			[
				{ imageName: "home256.png",          caption: "Home" },
				{ imageName: "announcements256.png", caption: "Notifications" },
				{ imageName: "skill-gap256.png",     caption: "Grades" },
				{ imageName: "maintenance256.png",   caption: "Profile Setting" }
			]

		getLoginArr: ->
			[
				{ imageName: "lessons256.png", caption: "About" },
				{ imageName: "Teachers256.png", caption: "Testimonials" },
				{ imageName: "Graduate-female512.png", caption: "Tutorials" },
				{ imageName: "wizard256.png", caption: "How to Join" }
			]


	App.reqres.setHandler "AppAdmin:docker:entities", ->
		API.getAppAdminDockerCollection()

	App.reqres.setHandler "OrgAdmin:docker:entities", ->
		API.getOrgAdminDockerCollection()

	App.reqres.setHandler "Student:docker:entities", ->
		API.getStudentDockerCollection()

	App.reqres.setHandler "Login:docker:entities", ->
		API.getLoginDockerCollection()

