@Learnster.module "Components.Tree", (Tree, App, Backbone, Marionette, $, _) ->

  class Tree.SideItem extends App.Views.ItemView
    template: 'tree/templates/_side_item'
    tagName: 'li'
    triggers:
        "click" : "side:item:link:clicked"

  class Tree.SideBar extends App.Views.CompositeView
    template: 'tree/templates/sidebar'
    itemView: Tree.SideItem
    itemViewContainer: 'ul.sidenav'

    onShow: ->
      route = App.getCurrentRoute()
      if App._isSideRoute(route)
        App.commands.execute "side:higlight:item", App.sideItemIdForRoute(route)
      else
        App.commands.execute "clear:sidebar:higlight"

    appendHtml: (collectionView, itemView, index) ->
      if not collectionView.collection.isEmpty()
        sideItemEntity = itemView.model
        if not sideItemEntity.get('isDiv')
          $sideItem = @$drawSideItem(sideItemEntity, itemView.$el)
          collectionView.$("ul.sidenav").append($sideItem[0])
        else
          @$drawSideDiv(collectionView, sideItemEntity)

    $drawSideDiv: (collectionView, sideItemEntity) ->
      divHtml = '<div style="margin-top: 1.9pc; height: 22pc;">' + sideItemEntity.get('text') + '</div>'
      collectionView.$('ul.sidenav').append(divHtml)

    $drawSideItem: (sideItemEntity, $itemView) ->
      text = sideItemEntity.get('text')
      if sideItemEntity.get('isHeader')
        $itemView.addClass('header')
        $itemView.append("<h3>#{text}</h3>")
      else
        $itemView.append(sideItemEntity.get('wrappingElem')).
          find("a").append(sideItemEntity.get('prependingElem') + " #{text}")
      $itemView.find("a").attr('id', sideItemEntity.
      get('id')) if sideItemEntity.get('id')
      $itemView



