@Learnster.module "CourseSectionsApp.New", (New, App, Backbone, Marionette, $, _) ->

  class New.Controller extends App.Controllers.Base

    initialize: (options = {}) ->
      @_nestingOrg = options.region?._nestingOrg

      courseSection = App.request "new:course_section:entity"
      @layout = @getLayoutView courseSection

      @listenTo courseSection, "created", ->
        App.vent.trigger "course_section:created", courseSection

      @listenTo @layout, "show", =>
        @setFormRegion courseSection

      @show @layout

    getLayoutView: (courseSection) ->
      new New.Layout
        model: courseSection

    getNewView: (courseSection) ->
      new New.View
        model: courseSection

    setFormRegion: (courseSection) ->
      newView = @getNewView courseSection
      formView = App.request "form:wrapper", newView
      @setProvisionerSelector()

      @listenTo newView, "form:cancel", =>
        @region.close()

      @layout.formRegion.show formView


    setProvisionerSelector: ->
      admins = App.request("org_admin:entities")
      selectView = App.request "selects:wrapper",
                    collection: admins
                    itemViewId: "provisioned_by"
                    itemView:   App.Components.Selects.UserOption
      @show selectView,
                            loading:
                                loadingType: "spinner"
                            region:  @newView.orgSelectRegion
