@Learnster.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.Submission extends Entities.Models
    urlRoot: Routes.api_submission_index_path()

  class Entities.SubmissionCollection extends Entities.Collections
    model: Entities.Submission

    initialize: (options = {}) =>
      @url = if options.url then options.url else Routes.api_submission_index_path()
      super


  API =
    getSubmission: (id) ->
      submission = Entities.Submission.findOrCreate
        id: id
      submission.fetch
        reset: true
      submission

    getSubmissionEntities: (deliverableId) ->
      submissions = new Entities.SubmissionCollection
        url: Routes.api_submission_index_path()
      submissions.fetch
        reset: true
        data: $.param
          page: 1
          deliverable_id: deliverableId
      submissions.put('deliverable_id', deliverableId)
      submissions

    getStudentSubmissionEntities: (studentId) ->
      submissions = new Entities.SubmissionCollection
        url: Routes.api_submission_index_path()
      submissions.fetch
        reset: true
        data: $.param
          page: 1
          student_id: studentId
      submissions.put('student_id', studentId)
      submissions

    getStudentDeliverableSubmissionEntities: (deliverableId, studentId) ->
      submissions = new Entities.SubmissionCollection
        url: Routes.api_submission_index_path()
      submissions.fetch
        reset: true
        data: $.param
          page: 1
          deliverable_id: deliverableId
          student_id:     studentId
      submissions.put('deliverable_id', deliverableId)
      submissions.put('student_id', studentId)
      submissions

    setCurrentSubmission: (attrs) ->
      new Entities.Submission attrs

    newSubmission: ->
      new Entities.Submission


  App.reqres.setHandler "submission:entities", (deliverableId) ->
    API.getSubmissionEntities(deliverableId)

  App.reqres.setHandler "student:submission:entities", (studentId) ->
    API.getStudentSubmissionEntities(studentId)

  App.reqres.setHandler "student:deliverable:submission:entities", (deliverableId, studentId) ->
    API.getStudentDeliverableSubmissionEntities(deliverableId, studentId)

  App.reqres.setHandler "new:submission:entity", ->
    API.newSubmission()

  App.reqres.setHandler "submission:entity", (id) ->
    API.getSubmission id

  App.reqres.setHandler "init:submission", (attrs) ->
    API.setCurrentSubmission attrs

