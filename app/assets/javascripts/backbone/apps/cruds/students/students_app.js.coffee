@Learnster.module "StudentsApp", (StudentsApp, App, Backbone, Marionette, $, _) ->

  class StudentsApp.Router extends App.Routers.AppRouter
    appRoutes:
      "student/:id/edit"    : "edit"
      "students"            : "listStudents"

  API =
    listStudents: ->
      new StudentsApp.List.Controller()

    newStudent: (region) ->
      new StudentsApp.New.Controller
        region: region

    edit: (id) ->
      new StudentsApp.Edit.Controller
          id: @get_student_id(id)

    get_student_id: (id_student) ->
      id = if id_student.id then id_student.id else id_student

    openImportDialog: (organisation) ->
      new StudentsApp.Import.Controller
        region: App.dialogRegion
        model: organisation

  App.commands.setHandler "new:student:view", (region) ->
    API.newStudent(region)

  App.vent.on "student:clicked student:created", (id) ->
    App.navigate Routes.edit_api_student_path(id).split("/api")[1]

  App.vent.on "student:cancelled student:updated", (student) ->
    App.goBack()

  App.vent.on "open:student:import:dialog", (organisation) ->
    API.openImportDialog organisation

  App.addInitializer ->
    new StudentsApp.Router
      controller: API
