@Learnster.module "LearningModulesApp.New", (New, App, Backbone, Marionette, $, _) ->

  class New.Controller extends App.Controllers.Base

    initialize: (options = {}) ->
      @_nestingOrgId = options.region?._nestingOrgId

      module = App.request "new:learning_module:entity"
      module.set('organisation_id', @_nestingOrgId)

      @layout = @getLayoutView module

      @listenTo module, "created", ->
        App.vent.trigger "learning_module:created", module

      @listenTo @layout, "show", =>
        @setFormRegion module

      @show @layout

    getLayoutView: (module) ->
      new New.Layout
        model: module

    getNewView: (module) ->
      new New.Module
        model: module

    setFormRegion: (module) ->
      @newView = @getNewView module
      formView = App.request "form:wrapper", @newView,
        toast:
          message: "module created"

      @listenTo formView, "show", ->
        @setEducatorSelector(formView)

      @listenTo @newView, "form:cancel", =>
        @region.close()

      @show formView,
        loading:
            loadingType: "spinner"
        region:  @layout.formRegion

    setEducatorSelector: (newLayout) ->
      user = App.currentUser

      orgId = @_nestingOrgId
      admins = App.request("org_admin:from:role:entities", orgId, "module_manager")
      selectView = App.request "selects:wrapper",
        collection: admins
        itemViewId: "educator"
        itemView:   App.Components.Selects.UserOption

      @listenTo selectView, "show", ->
        _.delay(( => $('.selectpicker').
                selectpicker('val', user.get('email'))) , 400)

      @show selectView,
        loading:
            loadingType: "spinner"
        region:  @newView.educatorSelectRegion
