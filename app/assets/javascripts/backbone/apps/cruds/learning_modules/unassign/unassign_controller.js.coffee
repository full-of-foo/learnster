@Learnster.module "LearningModulesApp.Unassign", (Unassign, App, Backbone, Marionette, $, _) ->

  class Unassign.Controller extends App.Controllers.Base

    initialize: (options = {}) ->
      @_nestingOrgId = options.region?._nestingOrgId
      @_nestingCourseSectionId = options.region?._nestingCourseSectionId
      sectionModule = App.request "new:section_module:entity"

      @layout = @getLayoutView sectionModule

      @listenTo sectionModule, "destroyed", ->
        App.vent.trigger "section_module:destroyed", sectionModule

      @listenTo @layout, "show", =>
        @setFormRegion sectionModule

      @show @layout

    getLayoutView: (sectionModule) ->
      new Unassign.Layout
        model: sectionModule

    getNewView: (sectionModule) ->
      new Unassign.Module
        model: sectionModule

    setFormRegion: (sectionModule) ->
      @newView = @getNewView sectionModule

      @listenTo @newView, "show", ->
        @setModuleSelector(@newView)

      @listenTo @newView, "remove:module:submitted", (view) ->
        dropDownValue = $("#unassign-module-section .filter-option").text().trim()
        moduleId = $("select option:contains('#{dropDownValue}')").attr('data-id')
        sectionModule.set("id", 0) # hack

        sectionModule.destroy
          data: $.param
            learning_module_id: moduleId
            course_section_id: @_nestingCourseSectionId

        sectionModule.on "destroy", => App.navigate "/course_section/#{@_nestingCourseSectionId}/show"

      @listenTo @newView, "form:cancel", =>
        @region.close()

      @show @newView,
        loading:
            loadingType: "spinner"
        region:  @layout.formRegion

    setModuleSelector: (newLayout) ->
      orgId = @_nestingOrgId
      modules = App.request("section:learning_module:entities", @_nestingCourseSectionId)
      selectView = App.request "selects:wrapper",
        collection: modules
        itemViewId: "learning_module"
        itemView:   App.Components.Selects.OrgOption

      @show selectView,
        loading:
            loadingType: "spinner"
        region:  @newView.moduleSelectRegion
