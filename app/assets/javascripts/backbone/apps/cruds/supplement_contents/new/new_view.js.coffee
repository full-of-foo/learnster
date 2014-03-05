@Learnster.module "SupplementContentsApp.New", (New, App, Backbone, Marionette, $, _, Routes, tinymce) ->

  class New.Layout extends App.Views.Layout
    template: "supplement_contents/new/templates/new_layout"
    regions:
      formRegion: "#form-region"

  class New.WikiView extends App.Views.Layout
    template: "supplement_contents/new/templates/new_wiki"
    triggers:
      "click .cancel-new-content" : "form:cancel"
    onShow: ->
      tinymce.init
        selector: "#wiki_markup",
        theme: "modern",
        skin: $('link')[1].href.replace('.css', '') if Learnster.environment is "production",
        skin_url: " " if Learnster.environment is "production",
        browser_spellcheck : true,
        plugins: [
            "advlist autolink lists link image charmap print preview hr anchor pagebreak",
            "searchreplace wordcount visualblocks visualchars code fullscreen",
            "insertdatetime media nonbreaking save table contextmenu directionality",
            "emoticons template paste textcolor"
        ],
        toolbar1: "insertfile undo redo | styleselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent",
        toolbar2: "print preview media | link image | forecolor backcolor emoticons",
        image_advtab: true

    form:
      buttons:
        primary: 	  "Create Wiki"
        primaryClass: "btn btn-primary"


  class New.UploadView extends App.Views.ItemView
    template: "supplement_contents/new/templates/new_upload"
    triggers:
      "click .cancel-new-content" : "form:cancel"

    form:
      buttons:
        primary: false
        cancel: false

    onShow: ->
      options =
        request:
          endpoint: Routes.api_content_upload_index_path()
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


, Routes, tinymce
