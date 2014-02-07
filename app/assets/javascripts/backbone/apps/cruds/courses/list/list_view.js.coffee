@Learnster.module "CoursesApp.List", (List, App, Backbone, Marionette, $, _) ->

  class List.Layout extends App.Views.Layout
    template: "courses/list/templates/list_layout"
    regions:
      panelRegion: "#panel-region"
      searchRegion: "#search-region"
      newRegion: "#new-region"
      coursesRegion: "#courses-region"

  class List.Panel extends App.Views.ItemView
    template: "courses/list/templates/_panel"
    initialize: (options) ->
      @setInstancePropertiesFor "templateHelpers"

    _closeDropdown: ->
      $('#list-panel .dropdown-toggle').dropdown('toggle')

    events:
      "click ul.dropdown-menu li" : "_closeDropdown"

    collectionEvents:
      "reset": "render"
    triggers:
      "click #new-course-button"   : "new:course:button:clicked"
      "click #import-dropdown-item" : "import:dropdown:clicked"

  class List.SearchPanel extends App.Views.ItemView
    template: "courses/list/templates/_search_panel"

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
    template: 'courses/list/templates/delete_dialog'
    tagName: 'div'
    className: 'modal fade'
    triggers:
      "click #delete-course-button" : "dialog:delete:course:clicked"

    onShow: ->
      @$el.modal()
