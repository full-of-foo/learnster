@Learnster.module "SupplementContentsApp.Edit", (Edit, App, Backbone, Marionette, $, _, tinymce) ->

  class Edit.Layout extends App.Views.Layout
    template: "supplement_contents/edit/templates/edit_layout"
    regions:
      formRegion: "#form-region"

  class Edit.Wiki extends App.Views.Layout
    template: "supplement_contents/edit/templates/edit_wiki"
    triggers:
      "click .cancel-edit-content" : "form:cancel"
      "click #preview-wiki-button" : "preview:wiki:clicked"

    onShow: ->
      tinymce.init
        selector: "#wiki_markup",
        theme: "modern",
        browser_spellcheck : true,
        plugins: [
            "advlist autolink lists link image charmap print preview hr anchor pagebreak",
            "searchreplace wordcount visualblocks visualchars code fullscreen",
            "insertdatetime media nonbreaking save table contextmenu directionality",
            "emoticons template paste textcolor"
        ],
        toolbar1: "insertfile undo redo | styleselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent",
        toolbar2: "print preview media |  link image | forecolor backcolor emoticons",
        image_advtab: true

    form:
      buttons:
        primary: 	  "Update Wiki"
        primaryClass: "btn btn-primary"

  class Edit.Preview extends App.Views.Layout
    template: "supplement_contents/edit/templates/show_wiki"
    triggers:
      "click .cancel-edit-content" : "form:cancel"
      "click #edit-wiki-button"    : "edit:wiki:clicked"


, tinymce
