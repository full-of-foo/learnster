@Learnster.module "OrgAdminsApp.Edit", (Edit, App, Backbone, Marionette, $, _) ->

  class Edit.Controller extends App.Controllers.Base

    initialize: (options) ->
      id = options.id
      @org_admin = App.request "org_admin:entity", id

      @listenTo @org_admin, "updated", ->
        App.vent.trigger "org_admin:updated", @org_admin

      App.execute "when:fetched", [@org_admin, App.currentUser], =>
        @layout = @getLayoutView @org_admin
        @listenTo @layout, "show", =>
          @setTitleRegion @org_admin
          @setFormRegion @org_admin

        @show @layout

    setFormRegion: (org_admin) ->
      @editView = @getEditView org_admin

      @listenTo @editView, "form:cancel", ->
        App.vent.trigger "org_admin:cancelled", org_admin

      user = App.request "get:current:user"
      createdByUser = org_admin.get('created_by').id is user.get('id') or user instanceof App.Entities.AppAdmin

      options =
        footer: if not createdByUser then false else true
        toast:
          message: "#{org_admin.get('full_name')} updated"

      formView = App.request "form:wrapper", @editView, options
      @layout.formRegion.show formView

    setTitleRegion: (org_admin) ->
      titleView = @getTitleView org_admin
      @layout.titleRegion.show titleView

    getLayoutView: (org_admin) ->
      new Edit.Layout
        model: org_admin

    getEditView: (org_admin) ->
      new Edit.OrgAdmin
        model: org_admin

    getTitleView: (org_admin) ->
      new Edit.Title
        model: org_admin
