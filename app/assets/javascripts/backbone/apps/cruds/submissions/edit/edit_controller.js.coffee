@Learnster.module "SubmissionsApp.Edit", (Edit, App, Backbone, Marionette, $, _, tinymce) ->

  class Edit.Controller extends App.Controllers.Base

    initialize: (options = {}) ->
      isPreview  = options.isPreview
      wikiId     = options.id
      versionId  = options.versionId

      App.execute "when:fetched", App.currentUser, =>
        submission = App.request "submission:entity", wikiId
        @layout    = @getLayoutView submission

        if isPreview
          @listenTo @layout, "show", =>
            @setWikiPreviewRegion(submission)

        else if not isPreview and not versionId
          @listenTo @layout, "show", =>
            @setWikiFormRegion(submission)

        else
          @listenTo @layout, "show", =>
            @setVerisonPreviewRegion(submission, versionId)

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

    getPreviewVersionView: (submission) ->
      new Edit.VersionPreview
        model: submission

    getVersionsView: (versions) ->
      new Edit.Versions
        collection: versions

    setWikiFormRegion: (submission) ->
      submission.urlRoot = Routes.api_wiki_submission_index_path()
      submission.beforeSave = @_scrapeWikiContent
      editView = @getEditWikiView submission
      formView = App.request "form:wrapper", editView,
        toast:
          message: "wiki updated"

      @listenTo submission, "updated", (submission) ->
        App.vent.trigger "wiki:submission:updated", submission

      @listenTo editView, "form:cancel", ->
        App.vent.trigger "wiki:submission:cancelled", submission

      @listenTo editView, "preview:wiki:clicked", ->
        App.vent.trigger "wiki:submission:clicked", submission

      @show formView,
        loading:
            loadingType: "spinner"
        region:  @layout.formRegion

    setWikiPreviewRegion: (submission) ->
      previewView = @getPreviewView submission

      @listenTo previewView, "edit:wiki:clicked", ->
        App.vent.trigger "edit:wiki:submission", submission

      @listenTo previewView, "show", ->
        @showVersionsList(previewView, submission)

      @show previewView,
        loading:
            loadingType: "spinner"
        region:  @layout.formRegion

    showVersionsList: (previewView, submission) ->
      versions = App.request "wiki:submission:versions", submission.get('id')
      versionsView = @getVersionsView(versions)

      @listenTo versionsView, "childview:clicked:wiki:version:link", (child, args) ->
        version       = args.model
        versionId     = version.get('id')
        deliverableId = submission.get('deliverable').id
        submissionId  = submission.get('id')
        App.navigate "/deliverable/#{deliverableId}/wiki_submission/#{submissionId}/version/#{versionId}/show"

      @show versionsView,
        loading:
            loadingType: "spinner"
        region: previewView.versionsRegion

    setVerisonPreviewRegion: (submission, versionId) ->
      oldSubmission = App.request "wiki:submission:by:version:entity", versionId
      versionView = @getPreviewVersionView oldSubmission

      @listenTo versionView, "form:cancel", =>
        App.vent.trigger "wiki:submission:cancelled", submission

      @listenTo versionView, "revert:wiki:clicked", =>
        revertVersion = App.request "revert:version:entity", versionId
        revertVersion.save()
        revertVersion.on "created", =>
          App.makeToast
            text: "wiki reverted"
            type: "info"
          App.vent.trigger("wiki:submission:updated", submission)

      @show versionView,
        loading:
            loadingType: "spinner"
        region:  @layout.formRegion

, tinymce
