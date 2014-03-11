@Learnster.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.WikiSubmissionVersion extends Entities.Models
    initialize: (options = {}) =>
      @urlRoot = if options.urlRoot then options.urlRoot else false
      super

  class Entities.WikiSubmissionVersionCollection extends Entities.Collections
    model: Entities.WikiSubmissionVersion

    initialize: (options = {}) =>
      @url = if options.url then options.url else false
      super


  API =
    getWikiSubmissionVersions: (submissionId) ->
      versions = new Entities.WikiSubmissionVersionCollection
        url: Routes.api_wiki_submission_versions_path(submissionId)
      versions.fetch
        reset: true
        data: $.param
          wiki_submission_id: submissionId
      versions

    getRevertVersionEntity: (versionId) ->
      version = new Entities.WikiSubmissionVersion
        urlRoot: Routes.api_wiki_submission_revert_path(versionId)
      version


  App.reqres.setHandler "wiki:submission:versions", (submissionId) ->
    API.getWikiSubmissionVersions(submissionId)

  App.reqres.setHandler "revert:version:entity", (versionId) ->
    API.getRevertVersionEntity(versionId)
