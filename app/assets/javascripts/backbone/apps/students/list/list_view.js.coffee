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


    class List.SettingsItem extends App.Views.ItemView
        template: "students/list/templates/_settings_item"
        tagName: 'li'
        triggers:
            "click a"   :  "setting:col:clicked"

    class List.SettingsList extends App.Views.CompositeView
        template: "students/list/templates/_settings"
        itemView: List.SettingsItem
        triggers:
            "click .settings-cancel" : "settings:cancel:clicked"

        initialize: (options) ->
            @setInstancePropertiesFor "templateHelpers"

        appendHtml: (collectionView, itemView, index) ->
            $li = itemView.$el
            col = itemView.model
            @drawFilterItem($li, col, collectionView, itemView)

         drawFilterItem: ($li, column, collectionView, itemView) =>
            if column.get('hasData')

                if column.get('isRemovable') and column.get('isShowing')
                    $li.addClass('active')
                else if not column.get('isRemovable') and column.get('isShowing')            
                    $li.addClass('disabled')

                if column.get('title')
                    title = column.get('title')
                    $li.append('<a href="#">' + title + '</a>')
                    
                collectionView.$("ul").append($li[0])


