@Learnster.module "LearningModulesApp.Assign", (Assign, App, Backbone, Marionette, $, _) ->

  class Assign.Controller extends App.Controllers.Base

    initialize: (options = {}) ->
      @_nestingOrgId = options.region?._nestingOrgId
      @_nestingCourseSectionId = options.region?._nestingCourseSectionId

      sectionModule = App.request "new:section_module:entity"
      sectionModule.set("course_section_id",  @_nestingCourseSectionId )


      @layout = @getLayoutView sectionModule

      @listenTo sectionModule, "created", ->
        App.vent.trigger "section_module:created", sectionModule

      @listenTo @layout, "show", =>
        @setFormRegion sectionModule

      @show @layout

    getLayoutView: (sectionModule) ->
      new Assign.Layout
        model: sectionModule

    getNewView: (sectionModule) ->
      new Assign.Module
        model: sectionModule

    setFormRegion: (sectionModule) ->
      @newView = @getNewView sectionModule
      formView = App.request "form:wrapper", @newView,
        toast:
          message: "module added"

      @listenTo formView, "show", ->
        @setModuleSelector(formView)

      @listenTo @newView, "form:cancel", =>
        @region.close()

      @show formView,
        loading:
            loadingType: "spinner"
        region:  @layout.formRegion

    setModuleSelector: (newLayout) ->
      orgId = @_nestingOrgId
      modules = App.request("learning_module:entities", orgId)
      selectView = App.request "selects:wrapper",
        collection: modules
        itemViewId: "learning_module"
        itemView:   App.Components.Selects.OrgOption

      @show selectView,
        loading:
            loadingType: "spinner"
        region:  @newView.moduleSelectRegion
