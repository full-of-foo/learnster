@Learnster.module "StudentsApp.New", (New, App, Backbone, Marionette, $, _) ->

  class New.Controller extends App.Controllers.Base

    initialize: (options = {}) ->
      @_nestingOrg = options.region?._nestingOrg
      student = App.request "new:student:entity"

      @layout = @getLayoutView student

      @listenTo student, "created", ->
        App.vent.trigger "student:created", student

      @listenTo @layout, "show", =>
        @setFormRegion student

      @show @layout


    getLayoutView: (student) ->
      new New.Layout
        model: student

    getNewView: (student) ->
      new New.View
        model: student

    setFormRegion: (student) ->
      @newView = @getNewView student
      formView = App.request "form:wrapper", @newView

      user = App.request "get:current:user"

      if user.get('type') is "AppAdmin"
        @listenTo @newView, "show", ->
          @setOrgSelector()

      @listenTo @newView, "form:cancel", =>
        @region.close()

      @layout.formRegion.show formView


    setOrgSelector: ->
      if @_nestingOrg
        orgs = App.request("new:org:entities")
        orgs.push(@_nestingOrg)
      else
        orgs = App.request("org:entities")

      selectView = App.request "selects:wrapper",
        collection: orgs
        itemViewId: "attending_org"
        itemView:   App.Components.Selects.OrgOption
      @show selectView,
        loading:
            loadingType: "spinner"
        region:  @newView.orgSelectRegion
