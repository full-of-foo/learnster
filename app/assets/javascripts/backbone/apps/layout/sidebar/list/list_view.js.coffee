@Learnster.module "SidebarApp.List", (List, App, Backbone, Marionette, $, _) ->

	class List.SideItem extends App.Views.ItemView
		template: 'sidebar/list/templates/_side_item'
		tagName: 'li'

	class List.SideBar extends App.Views.CompositeView
		template: 'sidebar/list/templates/sidebar'
		itemView: List.SideItem

		appendHtml: (collectionView, itemView, index) ->
			if not collectionView.collection.isEmpty()
				sideItemEntity = itemView.model

				$sideItem = @$drawSideItem(sideItemEntity, itemView.$el)
				collectionView.$("ul").append($sideItem[0])
			else
				console.log "oops"
				# TODO - append empty view

		$drawSideItem: (sideItemEntity, $itemView) ->
			# TODO - draw logic
			$itemView.text(sideItemEntity.get('text'))
