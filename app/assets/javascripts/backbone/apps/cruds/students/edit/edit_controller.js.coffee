@Learnster.module "StudentsApp.Edit", (Edit, App, Backbone, Marionette, $, _) ->

  class Edit.Controller extends App.Controllers.Base

    initialize: (options) ->
      id = options.id
      student = App.request "student:entity", id

      @listenTo student, "updated", ->
        App.vent.trigger "student:updated", student

      App.execute "when:fetched", student, =>
        @layout = @getLayoutView student
        @listenTo @layout, "show", =>
          @setTitleRegion student
          @setFormRegion student

        @show @layout

    getLayoutView: (student) ->
      new Edit.Layout
        model: student

    getEditView: (student) ->
      new Edit.Student
        model: student

    getTitleView: (student) ->
      new Edit.Title
        model: student

    setFormRegion: (student) ->
      editView = @getEditView student
      user = App.request "get:current:user"
      createdByUser = student.get('created_by').id is user.get('id') or user instanceof App.Entities.AppAdmin

      editView.removeButtons() if not createdByUser

      @listenTo editView, "form:cancel", ->
        App.vent.trigger "student:cancelled", student

      options =
        footer: if not createdByUser then false else true
        toast:
          message: "#{student.get('full_name')} updated"

      formView = App.request "form:wrapper", editView, options
      @layout.formRegion.show formView

    setTitleRegion: (student) ->
      titleView = @getTitleView student
      @layout.titleRegion.show titleView


