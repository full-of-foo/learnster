@Learnster.module "HeaderApp.List", (List, App, Backbone, Marionette, $, _) ->

	class List.DockItem extends App.Views.ItemView
		template: 'header/list/templates/_dock_item'

	class List.Docker extends App.Views.CompositeView
		template: 'header/list/templates/docker'
		itemView: List.DockItem
		itemViewContainer: 'ul'
		onShow: ->
			$('#dock').Fisheye
						maxWidth: 50
						items: 'li'
						itemsText: 'span'
						container: '.dock-container'
						itemWidth: 40
						proximity: 130
						halign : 'center'
		triggers:
			"click #home-dock-item"  : "home:dockItem:clicked"
			"click #stats-dock-item" : "stats:dockItem:clicked"
			"click #notifications-dock-item" : "notifications:dockItem:clicked"
			"click #about-dock-item" : "about:dockItem:clicked"
			"click #testimonials-dock-item" : "testimonials:dockItem:clicked"
			"click #join-dock-item" : "join:dockItem:clicked"
