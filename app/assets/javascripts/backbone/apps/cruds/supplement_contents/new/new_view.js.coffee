@Learnster.module "SupplementContentsApp.New", (New, App, Backbone, Marionette, $, _, Routes) ->

  class New.Layout extends App.Views.Layout
    template: "supplement_contents/new/templates/new_layout"
    regions:
      formRegion: "#form-region"


  class New.View extends App.Views.ItemView
    template: "supplement_contents/new/templates/new_content"
    triggers:
      "click .cancel-new-content" : "form:cancel"

    form:
      buttons:
        primary: false
        cancel: false

    onShow: ->
      options =
        request:
          endpoint: Routes.api_supplement_content_index_path()
          customHeaders:
            'X-CSRF-Token': $('meta[name="csrf-token"]').attr 'content'
            'Authorization': $.cookie('auth_header') if $.cookie('auth_header')
          validation:
            sizeLimit: 50000

      $('#content-upload-area').fineUploader(options).on 'submit', (id, name) =>
        formData = Backbone.Syphon.serialize(@['_formWrapper'])
        @model.set(formData)
        params = @model.toJSON()
        params['supplement_content'] = @model.toJSON()
        $('#content-upload-area').fineUploader('setParams', params)

      $('#content-upload-area').fineUploader(options).on 'error', (event, id, name, errorReason, xhrOrXdr) =>
        @model.set(_errors: $.parseJSON(xhrOrXdr.responseText)['errors'])

      $('#content-upload-area').fineUploader(options).on 'complete', (event, id, name, res) =>
        if res['file_upload']
          @model.set(_errors: {})
          @model.unset("_errors", { silent: true });
          @model.set(res)
          @model.trigger "created", @model


, Routes

