@Learnster.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.SubmissionUpload extends Entities.Models
    urlRoot: Routes.api_submission_upload_index_path()

  class Entities.SubmissionUploadCollection extends Entities.Collections
    model: Entities.SubmissionUpload

    initialize: (options = {}) =>
      @url = if options.url then options.url else Routes.api_submission_upload_index_path()
      super


  API =
    getSubmissionUpload: (id) ->
      submission = Entities.SubmissionUpload.findOrCreate
        id: id
      submission.fetch
        reset: true
      submission

    setCurrentSubmissionUpload: (attrs) ->
      new Entities.SubmissionUpload attrs

    newSubmissionUpload: ->
      new Entities.SubmissionUpload

  App.reqres.setHandler "new:submission:upload:entity", ->
    API.newSubmissionUpload()

  App.reqres.setHandler "submission:upload:entity", (id) ->
    API.getSubmissionUpload id

  App.reqres.setHandler "init:submission:upload", (attrs) ->
    API.setCurrentSubmissionUpload attrs
