@Learnster.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.SideItem extends Entities.Models

  class Entities.SideItemCollection extends Entities.Collections
    model: Entities.SideItem


  API =
    getSideItems: (sideItems, model) ->
      sideItems = @getDefaultSideItems sideItems
      new Entities.SideItemCollection(sideItems)

    getDefaultSideItems: (sideItems) ->
      items = []
      items.push(@getDefaultSideItem(sideItem)) for sideItem in sideItems
      items

    getDefaultSideItem: (sideItem) ->
      _.defaults sideItem,
        isHeader:  false
        className: false
        default:   false
        wrappingElem: '<a href="#"></a>'
        prependingElem: '<i class="icon-chevron-right"></i>'


  App.reqres.setHandler "sidebar:entities", (sideItems, model = null) ->
    API.getSideItems sideItems, model
