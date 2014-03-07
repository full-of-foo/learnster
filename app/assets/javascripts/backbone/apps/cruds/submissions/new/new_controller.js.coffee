@Learnster.module "SubmissionsApp.New", (New, App, Backbone, Marionette, $, _) ->

  class New.Controller extends App.Controllers.Base

    initialize: (options = {}) ->
      @_isUpload = if options.isUpload then options.isUpload else options.isWiki
      @nestedDeliverableId = options.nestedDeliverableId

      submission = if @_isUpload then App.request "new:submission:upload:entity" else App.request "new:wiki:submission:entity"
      submission.beforeSave = @_scrapeWikiContent if not @_isUpload
      submission.set('deliverable', {id: @nestedDeliverableId})

      @layout = @getLayoutView submission

      @listenTo submission, "created", (new_submission) =>
        @layout.close()
        App.vent.trigger "submission:created", new_submission

      @listenTo @layout, "show", =>
        if @_isUpload
          @setUploadFormRegion(submission)
        else
          @setWikiFormRegion(submission)

      @show @layout

    _scrapeWikiContent: (submission) ->
      submission.set('wiki_markup', tinymce.activeEditor.getContent())
      $('#wiki_markup').val(tinymce.activeEditor.getContent())

    getLayoutView: (submission) ->
      new New.Layout
        model: submission

    getNewUploadView: (submission) ->
      new New.UploadView
        model: submission

    getNewWikiView: (submission) ->
      new New.WikiView
        model: submission

    setWikiFormRegion: (submission) ->
      @newView = @getNewWikiView submission
      formView = App.request "form:wrapper", @newView
      @newView['_formWrapper'] = formView

      @listenTo @newView, "form:cancel", ->
        @region.close()

      @show formView,
        loading:
            loadingType: "spinner"
        region:  @layout.formRegion

    setUploadFormRegion: (submission) ->
      @newView = @getNewUploadView submission
      formView = App.request "form:wrapper", @newView
      @newView['_formWrapper'] = formView

      @listenTo @newView, "form:cancel", ->
        @region.close()

      @show formView,
        loading:
            loadingType: "spinner"
        region:  @layout.formRegion
