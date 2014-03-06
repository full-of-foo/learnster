@Learnster.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.WikiSubmission extends Entities.Models
    urlRoot: Routes.api_wiki_submission_index_path()

  class Entities.WikiSubmissionCollection extends Entities.Collections
    model: Entities.WikiSubmission

    initialize: (options = {}) =>
      @url = if options.url then options.url else Routes.api_wiki_submission_index_path()
      super


  API =
    getWikiSubmission: (id) ->
      submission = Entities.WikiSubmission.findOrCreate
        id: id
      submission.fetch
        reset: true
      submission

    setCurrentWikiSubmission: (attrs) ->
      new Entities.WikiSubmission attrs

    newWikiSubmission: ->
      new Entities.WikiSubmission

  App.reqres.setHandler "new:wiki:submission:entity", ->
    API.newWikiSubmission()

  App.reqres.setHandler "wiki:submission:entity", (id) ->
    API.getWikiSubmission id

  App.reqres.setHandler "init:wiki:submission", (attrs) ->
    API.setCurrentWikiSubmission attrs
