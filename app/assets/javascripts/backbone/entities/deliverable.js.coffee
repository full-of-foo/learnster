@Learnster.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.Deliverable extends Entities.Models
    urlRoot: Routes.api_deliverable_index_path()

  class Entities.DeliverableCollection extends Entities.Collections
    model: Entities.Deliverable

    initialize: (options = {}) =>
      @url = if options.url then options.url else Routes.api_deliverable_index_path()
      super


  API =
    getDeliverable: (id) ->
      content = Entities.Deliverable.findOrCreate
        id: id
      content.fetch
        reset: true
      content

    getSupplementDeliverableEntities: (supplementId) ->
      contents = new Entities.DeliverableCollection
        url: Routes.api_deliverable_index_path()
      contents.fetch
        reset: true
        data: $.param
          module_supplement_id: supplementId
      contents

    getEducatorDeliverableEntities: (educatorId) ->
      contents = new Entities.DeliverableCollection
        url: Routes.api_deliverable_index_path()
      contents.fetch
        reset: true
        data: $.param
          educator_id: educatorId
      contents

    getStudentDeliverableEntities: (studentId) ->
      contents = new Entities.DeliverableCollection
        url: Routes.api_deliverable_index_path()
      contents.fetch
        reset: true
        data: $.param
          student_id: studentId
      contents

    getOrgDeliverableEntities: (orgId) ->
      contents = new Entities.DeliverableCollection
        url: Routes.api_organisation_deliverable_index_path(orgId)
      contents.fetch
        reset: true
      contents

    setCurrentDeliverable: (attrs) ->
      new Entities.Deliverable attrs

    newDeliverable: ->
      new Entities.Deliverable


  App.reqres.setHandler "supplement:deliverable:entities", (supplementId) ->
    API.getSupplementDeliverableEntities(supplementId)

  App.reqres.setHandler "educator:deliverable:entities", (educatorId) ->
    API.getEducatorDeliverableEntities(educatorId)

  App.reqres.setHandler "student:deliverable:entities", (student) ->
    API.getStudentDeliverableEntities(student)

  App.reqres.setHandler "org:deliverable:entities", (orgId) ->
    API.getOrgDeliverableEntities(orgId)

  App.reqres.setHandler "new:deliverable:entity", ->
    API.newDeliverable()

  App.reqres.setHandler "deliverable:entity", (id) ->
    API.getDeliverable id

  App.reqres.setHandler "init:deliverable", (attrs) ->
    API.setCurrentDeliverable attrs

