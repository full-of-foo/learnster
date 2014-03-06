@Learnster.module "SupplementContentsApp.New", (New, App, Backbone, Marionette, $, _) ->

  class New.Controller extends App.Controllers.Base

    initialize: (options = {}) ->
      @_isUpload = if options.isUpload then options.isUpload else options.isWiki
      @nestedSupplementId = options.nestedSupplementId

      content = if @_isUpload then App.request "new:content:upload:entity" else App.request "new:wiki:content:entity"
      content.set('module_supplement', {id: @nestedSupplementId})

      @layout = @getLayoutView content

      @listenTo content, "created", (new_content) =>
        @layout.close()
        App.vent.trigger "content:created", new_content

      @listenTo @layout, "show", =>
        if @_isUpload
          @setUploadFormRegion(content)
        else
          @setWikiFormRegion(content)

      @show @layout

    getLayoutView: (content) ->
      new New.Layout
        model: content

    getNewUploadView: (content) ->
      new New.UploadView
        model: content

    getNewWikiView: (content) ->
      new New.WikiView
        model: content

    setWikiFormRegion: (content) ->
      @newView = @getNewWikiView content
      formView = App.request "form:wrapper", @newView
      @newView['_formWrapper'] = formView

      @listenTo @newView, "form:cancel", ->
        @region.close()

      @show formView,
        loading:
            loadingType: "spinner"
        region:  @layout.formRegion

    setUploadFormRegion: (content) ->
      @newView = @getNewUploadView content
      formView = App.request "form:wrapper", @newView
      @newView['_formWrapper'] = formView

      @listenTo @newView, "form:cancel", ->
        @region.close()

      @show formView,
        loading:
            loadingType: "spinner"
        region:  @layout.formRegion
