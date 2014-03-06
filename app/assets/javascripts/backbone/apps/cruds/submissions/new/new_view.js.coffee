@Learnster.module "SubmissionsApp.New", (New, App, Backbone, Marionette, $, _, Routes, tinymce) ->

  class New.Layout extends App.Views.Layout
    template: "submissions/new/templates/new_layout"
    regions:
      formRegion: "#form-region"

  class New.WikiView extends App.Views.Layout
    template: "submissions/new/templates/new_wiki"
    triggers:
      "click .cancel-new-submission" : "form:cancel"
    onShow: ->
      tinymce.init
        selector: "#wiki_markup",
        theme: "modern",
        skin_url: "/non_compile/tiny/lightgray",
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
    template: "submissions/new/templates/new_upload"
    triggers:
      "click .cancel-new-submission" : "form:cancel"

    form:
      buttons:
        primary: false
        cancel: false

    onShow: ->
      options =
        request:
          endpoint: Routes.api_submission_upload_index_path()
          customHeaders:
            'X-CSRF-Token': $('meta[name="csrf-token"]').attr 'content'
            'Authorization': $.cookie('auth_header') if $.cookie('auth_header')
          validation:
            sizeLimit: 50000

      $('#submission-upload-area').fineUploader(options).on 'submit', (id, name) =>
        formData = Backbone.Syphon.serialize(@['_formWrapper'])
        @model.set(formData)
        params = @model.toJSON()
        params['submission'] = @model.toJSON()
        $('#submission-upload-area').fineUploader('setParams', params)

      $('#submission-upload-area').fineUploader(options).on 'error', (event, id, name, errorReason, xhrOrXdr) =>
        @model.set(_errors: $.parseJSON(xhrOrXdr.responseText)['errors'])

      $('#submission-upload-area').fineUploader(options).on 'complete', (event, id, name, res) =>
        if res['file_upload']
          @model.set(_errors: {})
          @model.unset("_errors", { silent: true });
          @model.set(res)
          @model.trigger "created", @model


, Routes, tinymce
