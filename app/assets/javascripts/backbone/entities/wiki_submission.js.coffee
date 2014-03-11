@Learnster.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.WikiSubmission extends Entities.Models
    initialize: (options = {}) =>
      @urlRoot = if options.urlRoot then options.urlRoot else Routes.api_wiki_submission_index_path()
      super

  API =
    getWikiSubmissionVersion: (versionId) ->
      submission = new Entities.WikiSubmission
        urlRoot: Routes.api_wiki_submission_version_path(versionId)
      submission.fetch
        reset: true
        data:
          version_id: versionId
      submission

    setCurrentWikiSubmission: (attrs) ->
      new Entities.WikiSubmission attrs

    newWikiSubmission: ->
      new Entities.WikiSubmission

  App.reqres.setHandler "new:wiki:submission:entity", ->
    API.newWikiSubmission()

  App.reqres.setHandler "wiki:submission:entity", (id) ->
    API.getWikiSubmission id

  App.reqres.setHandler "wiki:submission:by:version:entity", (versionId) ->
    API.getWikiSubmissionVersion versionId

  App.reqres.setHandler "init:wiki:submission", (attrs) ->
    API.setCurrentWikiSubmission attrs
