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
      deliverable = Entities.Deliverable.findOrCreate
        id: id
      deliverable.fetch
        reset: true
      deliverable

    getSupplementDeliverableEntities: (supplementId) ->
      deliverables = new Entities.DeliverableCollection
        url: Routes.api_deliverable_index_path()
      deliverables.fetch
        reset: true
        data: $.param
          page: 1
          module_supplement_id: supplementId
      deliverables.put('module_supplement_id', supplementId)
      deliverables

    getEducatorDeliverableEntities: (educatorId) ->
      deliverables = new Entities.DeliverableCollection
        url: Routes.api_deliverable_index_path()
      deliverables.fetch
        reset: true
        data: $.param
          page: 1
          educator_id: educatorId
      deliverables.put('educator_id', educatorId)
      deliverables

    getStudentDeliverableEntities: (studentId) ->
      deliverables = new Entities.DeliverableCollection
        url: Routes.api_deliverable_index_path()
      deliverables.fetch
        reset: true
        data: $.param
          page: 1
          student_id: studentId
      deliverables.put('student_id', studentId)
      deliverables

    getStudentDeliverableDeliverableEntities: (deliverableId, studentId) ->
      deliverables = new Entities.DeliverableCollection
        url: Routes.api_deliverable_index_path()
      deliverables.fetch
        reset: true
        data: $.param
          page: 1
          student_id: studentId
          deliverable_id: deliverableId

      deliverables.put('student_id',     studentId)
      deliverables.put('deliverable_id', deliverableId)
      deliverables

    getOrgDeliverableEntities: (orgId) ->
      deliverables = new Entities.DeliverableCollection
        url: Routes.api_organisation_deliverable_index_path(orgId)
      deliverables.fetch
        data:
          page: 1
        reset: true
      deliverables

    getSearchDeliverableEntities: (searchOpts) ->
      { term, supplementId, adminId, studentId } = searchOpts
      deliverables = new Entities.DeliverableCollection

      term['module_supplement_id'] = supplementId if supplementId
      term['educator_id']          = adminId      if adminId
      term['student_id']           = studentId    if studentId
      deliverables.fetch
        reset: true
        data: $.param(term)

      deliverables.put('search',               term['search'])
      deliverables.put('educator_id',          term['educator_id'])
      deliverables.put('module_supplement_id', term['module_supplement_id'])
      deliverables.put('student_id',           term['student_id'])
      deliverables

    setCurrentDeliverable: (attrs) ->
      new Entities.Deliverable attrs

    newDeliverable: ->
      new Entities.Deliverable


  App.reqres.setHandler "supplement:deliverable:entities", (supplementId) ->
    API.getSupplementDeliverableEntities(supplementId)

  App.reqres.setHandler "educator:deliverable:entities", (educatorId) ->
    API.getEducatorDeliverableEntities(educatorId)

  App.reqres.setHandler "student:deliverable:entities", (studentId) ->
    API.getStudentDeliverableEntities(studentId)

  App.reqres.setHandler "org:deliverable:entities", (orgId) ->
    API.getOrgDeliverableEntities(orgId)

  App.reqres.setHandler "new:deliverable:entity", ->
    API.newDeliverable()

  App.reqres.setHandler "deliverable:entity", (id) ->
    API.getDeliverable id

  App.reqres.setHandler "init:deliverable", (attrs) ->
    API.setCurrentDeliverable attrs

