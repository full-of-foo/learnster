@Learnster.module "Components.Tree", (Tree, App, Backbone, Marionette, $, _) ->

	class Tree.SideItem extends App.Views.ItemView
		template: 'tree/templates/_side_item'
		tagName: 'li'

	class Tree.SideBar extends App.Views.CompositeView
		template: 'tree/templates/sidebar'
		itemView: Tree.SideItem
		itemViewContainer: 'ul.sidenav'

		appendHtml: (collectionView, itemView, index) ->
			if not collectionView.collection.isEmpty()
				sideItemEntity = itemView.model
				$sideItem = @$drawSideItem(sideItemEntity, itemView.$el)
				collectionView.$("ul.sidenav").append($sideItem[0])


		$drawSideItem: (sideItemEntity, $itemView) ->
			text = sideItemEntity.get('text')
			if sideItemEntity.get('isHeader')
				$itemView.addClass('header')
				$itemView.append("<h3>#{text}</h3>")
			else
				$itemView.append(sideItemEntity.get('wrappingElem')).\
				find("a").append(sideItemEntity.get('prependingElem') + " #{text}")
				$itemView.addClass('active') if sideItemEntity.get('default')
			$itemView


