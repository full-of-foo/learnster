@Learnster.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.ContentUpload extends Entities.Models
    urlRoot: Routes.api_content_upload_index_path()

  class Entities.ContentUploadCollection extends Entities.Collections
    model: Entities.ContentUpload

    initialize: (options = {}) =>
      @url = if options.url then options.url else Routes.api_content_upload_index_path()
      super


  API =
    getContentUpload: (id) ->
      content = Entities.ContentUpload.findOrCreate
        id: id
      content.fetch
        reset: true
      content

    setCurrentContentUpload: (attrs) ->
      new Entities.ContentUpload attrs

    newContentUpload: ->
      new Entities.ContentUpload

  App.reqres.setHandler "new:content:upload:entity", ->
    API.newContentUpload()

  App.reqres.setHandler "content:upload:entity", (id) ->
    API.getContentUpload id

  App.reqres.setHandler "init:content:upload", (attrs) ->
    API.setCurrentContentUpload attrs
