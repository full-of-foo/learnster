@Learnster.module "OrgAdminsApp.List", (List, App, Backbone, Marionette, $, _) ->

    class List.Layout extends App.Views.Layout
      template: "org_admins/list/templates/list_layout"
      regions:
        panelRegion: "#panel-region"
        searchRegion: "#search-region"
        newRegion: "#new-region"
        listSettingsRegion: "#list-settings-region"
        orgAdminsRegion: "#org-admin-region"

    class List.Panel extends App.Views.ItemView
      template: "org_admins/list/templates/_panel"

      initialize: (options) ->
        @setInstancePropertiesFor "templateHelpers"

      collectionEvents:
        "reset": "render"
      triggers:
        "click #new-org-admin-button" : "new:org_admin:button:clicked"
        "click #list-settings-button" : "settings:button:clicked"

    class List.SearchPanel extends App.Views.ItemView
      template: "org_admins/list/templates/_search_panel"

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
      template: 'org_admins/list/templates/delete_dialog'
      tagName: 'div'
      className: 'modal fade'
      triggers:
        "click #delete-org-admin-button" : "dialog:delete:admin:clicked"

      onShow: ->
        @$el.modal()



