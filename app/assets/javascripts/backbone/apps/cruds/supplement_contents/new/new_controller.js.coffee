@Learnster.module "SupplementContentsApp.New", (New, App, Backbone, Marionette, $, _) ->

  class New.Controller extends App.Controllers.Base

    initialize: (options = {}) ->
      @nestedSupplementId = options.nestedSupplementId

      content = App.request "new:supplement:content:entity"
      content.set('module_supplement', {id: @nestedSupplementId})

      @layout = @getLayoutView content

      @listenTo content, "created", (new_content) =>
        @layout.close()
        App.vent.trigger "content:created", new_content

      @listenTo @layout, "show", =>
        @setFormRegion content

      @show @layout

    getLayoutView: (content) ->
      new New.Layout
        model: content

    getNewView: (content) ->
      new New.View
        model: content

    setFormRegion: (content) ->
      @newView = @getNewView content
      formView = App.request "form:wrapper", @newView
      @newView['_formWrapper'] = formView

      @listenTo @newView, "form:cancel", ->
        @region.close()

      @show formView,
        loading:
            loadingType: "spinner"
        region:  @layout.formRegion
