@Learnster.module "LearningModulesApp.Edit", (Edit, App, Backbone, Marionette, $, _) ->

  class Edit.Controller extends App.Controllers.Base

    initialize: (options) ->
      id = options.id
      module = App.request "learning_module:entity", id

      @listenTo module, "updated", ->
        App.vent.trigger "module:updated", module

      @layout = @getLayoutView module
      @listenTo @layout, "show", =>
        @setTitleRegion module
        @setFormRegion module

      @show @layout

    getLayoutView: (module) ->
      new Edit.Layout
        model: module

    getEditView: (module) ->
      new Edit.Module
        model: module

    getTitleView: (module) ->
      new Edit.Title
        model: module

    setFormRegion: (module) ->
      @editView = @getEditView module

      @listenTo @editView, "form:cancel", ->
        App.vent.trigger "module:cancelled", module

      formView = App.request "form:wrapper", @editView

      @listenTo formView, "show", ->
        orgId = module.get('organisation_id')
        @setEducatorSelector(formView, orgId)

      @show formView,
        loading:
          loadingType: "spinner"
        region:  @layout.formRegion


    setTitleRegion: (module) ->
      titleView = @getTitleView module
      @show titleView,
        loading:
          loadingType: "spinner"
        region:  @layout.titleRegion

    setEducatorSelector: (formView, orgId) ->
      admins = App.request("org_admin:from:role:entities", orgId, "module_manager")
      selectView = App.request "selects:wrapper",
        collection: admins
        itemViewId: "educator"
        itemView:   App.Components.Selects.UserOption

      @show selectView,
        loading:
            loadingType: "spinner"
        region:  @editView.educatorSelectRegion
