@Learnster.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.Collections extends Backbone.Collection

    initialize: ->
      @_meta = {}
      if App.request("app:environment") is "development"
        @on "all", (e) -> console.log e
      @on "unpermitted:entity", (collection) ->
          App.commands.execute("show:not:found")

      @on "synced:pagninable:collection", (collection, linksHeader) ->
        @_meta['next_link'] = @_formatNextLinkHeader(linksHeader)
        @_meta['last_link'] = @_formatLastLinkHeader(linksHeader)

    put: (prop, value) ->
      @_meta[prop] = value

    get: (prop) ->
      @_meta[prop]

    fetch: (options = {}) ->
      # options.reset = true
      super options

    _formatNextLinkHeader: (linksHeader) ->
      if /rel="next"/i.test(linksHeader)
        @_meta['next_link'] = (/"last",.*?page=(\d+).*?>; rel="next"/i.exec(linksHeader))[1]
      else
        false

    _formatLastLinkHeader: (linksHeader) ->
      if /rel="last"/i.test(linksHeader)
        if /rel="prev"/i.test(linksHeader)
          @_meta['last_link'] = (/"prev".+page=(\d+).*?>; rel="last"/i.exec(linksHeader))[1]
        else
          @_meta['last_link'] = (/page=(\d+).*?>; rel="last"/i.exec(linksHeader))[1]
      else
        @_meta['last_link'] = @_meta['next_link']
