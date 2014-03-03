@Learnster.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.WikiContent extends Entities.Models
    urlRoot: Routes.api_wiki_content_index_path()

  class Entities.WikiContentCollection extends Entities.Collections
    model: Entities.WikiContent

    initialize: (options = {}) =>
      @url = if options.url then options.url else Routes.api_wiki_content_index_path()
      super


  API =
    getWikiContent: (id) ->
      content = Entities.WikiContent.findOrCreate
        id: id
      content.fetch
        reset: true
      content

    setCurrentWikiContent: (attrs) ->
      new Entities.WikiContent attrs

    newWikiContent: ->
      new Entities.WikiContent

  App.reqres.setHandler "new:wiki:content:entity", ->
    API.newWikiContent()

  App.reqres.setHandler "wiki:content:entity", (id) ->
    API.getWikiContent id

  App.reqres.setHandler "init:wiki:content", (attrs) ->
    API.setCurrentWikiContent attrs
