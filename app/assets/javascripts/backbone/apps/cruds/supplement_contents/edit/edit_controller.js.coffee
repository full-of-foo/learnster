@Learnster.module "SupplementContentsApp.Edit", (Edit, App, Backbone, Marionette, $, _, tinymce) ->

  class Edit.Controller extends App.Controllers.Base

    initialize: (options = {}) ->
      @isPreview    = options.isPreview
      @wikiId       = options.id
      @moduleId     = options.moduleId
      @supplementId = options.supplementId

      content = App.request "wiki:content:entity", @wikiId
      content.beforeSave = @_scrapeWikiContent

      @layout = @getLayoutView content

      if not @isPreview
        @listenTo content, "updated", (new_content) =>
          App.navigate "module/#{@moduleId}/supplement/#{@supplementId}/wiki/#{@wikiId}/show"

        @listenTo @layout, "show", =>
          @setWikiFormRegion(content)
      else
        @listenTo @layout, "show", =>
          @setWikiPreviewRegion(content)

      @show @layout

    _scrapeWikiContent: (content) ->
      content.set('wiki_markup', tinymce.activeEditor.getContent())
      $('#wiki_markup').val(tinymce.activeEditor.getContent())

    getLayoutView: (content) ->
      new Edit.Layout
        model: content

    getEditWikiView: (content) ->
      new Edit.Wiki
        model: content

    getPreviewView: (content) ->
      new Edit.Preview
        model: content

    setWikiFormRegion: (content) ->
      @editView = @getEditWikiView content
      formView = App.request "form:wrapper", @editView

      @listenTo @editView, "form:cancel", ->
        App.vent.trigger "edit:wiki:cancel", @moduleId, @supplementId

      @listenTo @editView, "preview:wiki:clicked", ->
        App.navigate "module/#{@moduleId}/supplement/#{@supplementId}/wiki/#{@wikiId}/show"

      @show formView,
        loading:
            loadingType: "spinner"
        region:  @layout.formRegion

    setWikiPreviewRegion: (content) ->
      @previewView = @getPreviewView content

      @listenTo @previewView, "edit:wiki:clicked", ->
        App.navigate "module/#{@moduleId}/supplement/#{@supplementId}/wiki/#{@wikiId}/edit"

      @show @previewView,
        loading:
            loadingType: "spinner"
        region:  @layout.formRegion

, tinymce
