@Learnster.module "Components.List", (List, App, Backbone, Marionette, $, _) ->

  class List.Controller extends App.Controllers.Base
    initialize: (options = {}) ->
      { @collection, config } = options
      @listView = @getListView config

    getListView: (config) ->
      config = @getDefaultConfig config

      new List.Wrapper
        collection: @collection
        config:     config
        itemViewOptions: config.itemProperties

    getDefaultConfig: (config = {}) ->
      _.defaults config,
        isPaginable:    true
        listClassName: 'span'
        emptyMessage:   "No items founds :("

    getColumns: (cols) ->
      App.request("table:column:entities", cols, false)


  App.reqres.setHandler "list:wrapper", (collection, options) ->
    listController = new List.Controller
      collection: collection
      region:     options.region if options.region
      config:     options.config
    listController.listView
