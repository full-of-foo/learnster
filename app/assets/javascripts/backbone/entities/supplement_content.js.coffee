@Learnster.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.SupplementContent extends Entities.Models
    urlRoot: Routes.api_supplement_content_index_path()

  class Entities.SupplementContentCollection extends Entities.Collections
    model: Entities.SupplementContent

    initialize: (options = {}) =>
      @url = if options.url then options.url else Routes.api_supplement_content_index_path()
      super


  API =
    getSupplementContent: (id) ->
      content = Entities.SupplementContent.findOrCreate
        id: id
      content.fetch
        reset: true
      content

    getSupplementContentEntities: (supplementId) ->
      contents = new Entities.SupplementContentCollection
        url: Routes.api_supplement_content_index_path()
      contents.fetch
        reset: true
        data: $.param
          module_supplement_id: supplementId
      contents

    setCurrentSupplementContent: (attrs) ->
      new Entities.SupplementContent attrs

    newSupplementContent: ->
      new Entities.SupplementContent


  App.reqres.setHandler "supplement:content:entities", (supplementId) ->
    API.getSupplementContentEntities(supplementId)

  App.reqres.setHandler "new:supplement:content:entity", ->
    API.newSupplementContent()

  App.reqres.setHandler "supplement:content:entity", (id) ->
    API.getSupplementContent id

  App.reqres.setHandler "init:supplement:content", (attrs) ->
    API.setCurrentSupplementContent attrs

