@Learnster.module "StudentsApp.List", (List, App, Backbone, Marionette, $, _) ->

  class List.Layout extends App.Views.Layout
    template: "students/list/templates/list_layout"
    regions:
      panelRegion: "#panel-region"
      searchRegion: "#search-region"
      newRegion: "#new-region"
      listSettingsRegion: "#list-settings-region"
      studentsRegion: "#students-region"

  class List.Panel extends App.Views.ItemView
    template: "students/list/templates/_panel"

    initialize: (options) ->
      @setInstancePropertiesFor "templateHelpers"

    collectionEvents:
      "reset": "render"
    triggers:
      "click #new-student-button"   : "new:student:button:clicked"
      "click #list-settings-button" : "settings:button:clicked"
      "click #import-dropdown-item" : "import:dropdown:clicked"

  class List.SearchPanel extends App.Views.ItemView
    template: "students/list/templates/_search_panel"

    initialize: (options) ->
      @setInstancePropertiesFor "templateHelpers"
    ui:
      "input" : "input"
    events:
      "submit form" : "formSubmitted"

    formSubmitted: (e) ->
      e.preventDefault()
      data = Backbone.Syphon.serialize @
      @trigger "search:submitted", data

  class List.DeleteDialog extends App.Views.ItemView
    template: 'students/list/templates/delete_dialog'
    tagName: 'div'
    className: 'modal fade'
    triggers:
      "click #delete-student-button" : "dialog:delete:student:clicked"

    onShow: ->
      @$el.modal()
