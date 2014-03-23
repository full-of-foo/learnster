@Learnster.module "Components.Selects", (Selects, App, Backbone, Marionette, $, _) ->

  App.reqres.setHandler "selects:wrapper", (options = {}) ->
    new Selects.Wrapper
      itemViewId: options.itemViewId
      itemView: options.itemView
      emptyView: options.emptyView
      collection: options.collection
