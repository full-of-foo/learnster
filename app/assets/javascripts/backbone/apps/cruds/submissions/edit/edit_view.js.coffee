@Learnster.module "SubmissionsApp.Edit", (Edit, App, Backbone, Marionette, $, _, tinymce) ->

  class Edit.Layout extends App.Views.Layout
    template: "submissions/edit/templates/edit_layout"
    regions:
      formRegion: "#form-region"

  class Edit.Wiki extends App.Views.Layout
    template: "submissions/edit/templates/edit_wiki"
    triggers:
      "click .cancel-edit-content" : "form:cancel"
      "click #preview-wiki-button" : "preview:wiki:clicked"

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
        toolbar2: "print preview media |  link image | forecolor backcolor emoticons",
        image_advtab: true

    form:
      buttons:
        primary: 	  "Update Wiki"
        primaryClass: "btn btn-primary"

  class Edit.Preview extends App.Views.Layout
    template: "submissions/edit/templates/show_wiki"
    regions:
      versionsRegion: "#versions-region"
    triggers:
      "click .cancel-edit-submission" : "form:cancel"
      "click #edit-wiki-button"       : "edit:wiki:clicked"

  class Edit.VersionPreview extends App.Views.ItemView
    template: "submissions/edit/templates/show_version"
    triggers:
      "click #cancel-wiki-version" : "form:cancel"
      "click #revert-wiki-button"  : "revert:wiki:clicked"

  class Edit.Version extends App.Views.ItemView
    template: "submissions/edit/templates/_version"
    tagName: "li"
    triggers:
      "click" : "clicked:wiki:version:link"

  class Edit.EmptyVersions extends App.Views.ItemView
    template: "submissions/edit/templates/_empty_versions"
    tagName: "li"

  class Edit.Versions extends App.Views.CompositeView
    template: 'submissions/edit/templates/versions'
    itemView: Edit.Version
    itemViewContainer: 'ul'
    emptyView: Edit.EmptyVersions

, tinymce
