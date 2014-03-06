@Learnster.module "SubmissionsApp.Edit", (Edit, App, Backbone, Marionette, $, _, tinymce) ->

  class Edit.Controller extends App.Controllers.Base

    initialize: (options = {}) ->
      @isPreview     = options.isPreview
      @wikiId        = options.id
      @deliverableId = options.deliverableId

      submission = App.request "wiki:submission:entity", @wikiId
      submission.beforeSave = @_scrapeWikiContent

      @layout = @getLayoutView submission

      if not @isPreview
        @listenTo submission, "updated", (new_submission) =>
          App.vent.trigger "wiki:submission:updated", new_submission

        @listenTo @layout, "show", =>
          @setWikiFormRegion(submission)
      else
        @listenTo @layout, "show", =>
          @setWikiPreviewRegion(submission)

      @show @layout

    _scrapeWikiContent: (submission) ->
      submission.set('wiki_markup', tinymce.activeEditor.getContent())
      $('#wiki_markup').val(tinymce.activeEditor.getContent())

    getLayoutView: (submission) ->
      new Edit.Layout
        model: submission

    getEditWikiView: (submission) ->
      new Edit.Wiki
        model: submission

    getPreviewView: (submission) ->
      new Edit.Preview
        model: submission

    setWikiFormRegion: (submission) ->
      @editView = @getEditWikiView submission
      formView = App.request "form:wrapper", @editView

      @listenTo @editView, "form:cancel", ->
        App.vent.trigger "wiki:submission:cancelled", submission

      @listenTo @editView, "preview:wiki:clicked", ->
        App.vent.trigger "wiki:submission:clicked", submission

      @show formView,
        loading:
            loadingType: "spinner"
        region:  @layout.formRegion

    setWikiPreviewRegion: (submission) ->
      @previewView = @getPreviewView submission

      @listenTo @previewView, "edit:wiki:clicked", ->
        App.vent.trigger "edit:wiki:submission", submission

      @show @previewView,
        loading:
            loadingType: "spinner"
        region:  @layout.formRegion

, tinymce
