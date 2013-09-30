@Learnster.module "Components.Table", (Table, App, Backbone, Marionette, $, _) ->

    class Table.SettingsItem extends App.Views.ItemView
        template: "table/_settings_item"
        tagName: 'li'
        triggers:
            "click a"   :  "setting:col:clicked"

    class Table.Settings extends App.Views.CompositeView
        template: "table/_settings"
        triggers:
            "click button.cancel-settings" : "close"

        onClose: ->
            @close()

        itemView: Table.SettingsItem

        initialize: (options) ->
            @setInstancePropertiesFor "templateHelpers"

        appendHtml: (collectionView, itemView, index) ->
            $li = itemView.$el
            col = itemView.model
            @drawFilterItem($li, col, collectionView, itemView)

         drawFilterItem: ($li, columnFilterItem, collectionView, itemView) =>
            if columnFilterItem.get('hasData')

                if columnFilterItem.get('isRemovable') and columnFilterItem.get('isShowing')
                    $li.addClass('active')
                else if not columnFilterItem.get('isRemovable') and columnFilterItem.get('isShowing')            
                    $li.addClass('disabled')

                if columnFilterItem.get('title')
                    title = columnFilterItem.get('title')
                    $li.append('<a href="#">' + title + '</a>')
                    
                collectionView.$("ul").append($li[0])


    class Table.Empty extends App.Views.ItemView
        template: "table/_empty_item"
        tagName: "tr"

    class Table.Item extends App.Views.ItemView
        template: "table/_table_item"
        tagName: "tr"
        initialize: (options) ->
            @setInstancePropertiesFor "triggers"

    class Table.Wrapper extends App.Views.CompositeView
        template: "table/table_items"
        itemView: Table.Item
        emptyView: Table.Empty
        ui:
            table:      "table#app-table"
            headerRow:  "tr#app-table-header-row"

        collectionEvents:
            "reset": "render"

        initialize: (options) ->
            { @columns, @config } = options
            @columns = @columns.models
            @defaultColumns = @getDefaultColumns @columns

            @setInstancePropertiesFor "itemViewOptions"

        onShow: ->
            @drawColumnHeaders @columns
            @styleTable @config.tableClassName

        toggleColumn: (filterItemView, filterColumn) ->
            $li = filterItemView.$el
            $tableCol = @$getTableColumn(filterColumn)
            isRemovable = filterColumn.get('isRemovable')
            isShowing = filterColumn.get('isShowing')

            if isRemovable and isShowing
                @hideColumn(filterColumn, $li, $tableCol)

            if isRemovable and not isShowing
                @showColumn(filterColumn, $li, $tableCol)


        hideColumn: (filterColumn, $li, $tableCol) ->
            filterColumn.set('isShowing', false)
            $li.removeClass('active')
            $tableCol.addClass('hide')

        showColumn: (filterColumn, $li, $tableCol) ->
            filterColumn.set('isShowing', true)
            $li.addClass('active')
            $tableCol.removeClass('hide')

        drawColumnHeaders: (columns) ->
            @drawHeader(column) for column in columns
            @ui.table.tablesorter()

        drawHeader: (column) ->
            $column = @$setColumnHeader column
            @ui.headerRow.append($column)

        $setColumnHeader: (column) ->
            colIndex = @columns.indexOf(column)
            $column = if column.get('htmlHeader') then $("<th>" + column.get('htmlHeader') + "</th>") else $("<th>" + column.get('title') + "</th>")
            $column.addClass "col-#{colIndex}"
            $column.addClass "{sorter: false}" if not column.get('isSortable')
            $column.addClass column.get('className') if column.get('className')
            $column.addClass 'hide' if not column.get('default')
            $column[0]

        appendHtml: (collectionView, itemView, index) ->
            if not collectionView.collection.isEmpty()
                $row = itemView.$el
                model = itemView.model
                @drawCell(col, $row, model, itemView, index) for col in @columns
                collectionView.$("tbody").append($row[0])
            else
                emptyCell = "<td colspan='#{@columns.length}'>#{@config.emptyMessage}</td>"
                collectionView.$("tbody").append(emptyCell)


        drawCell: (col, $row, model, itemView, index) ->
            colIndex = @columns.indexOf(col)
            $cell = $("<td></td>")
            $cell.addClass "col-#{colIndex}"

            if col.get('className')
                $cell.addClass(col.get('className'))

            if col.get('attrName')
                attr = col.get('attrName')
                $row.append($cell.append(model.get(attr)))

            if col.get('htmlContent')
                t = _.template(col.get('htmlContent'), { model : model })
                $row.append($cell.append(t))

            if not col.get('default')
                $cell.addClass('hide')


        styleTable: (className) ->
            @ui.table.addClass className

        $getTableColumn: (filterColumn) ->
            column = (col for col in @columns when col.get('title') == filterColumn.get('title'))[0]
            if not column 
                @columns.push filterColumn
                colIndex = @columns.indexOf filterColumn
            else
                colIndex = @columns.indexOf column

            $(".col-#{colIndex}")

        getDefaultColumns: (columns) ->
            (col for col in columns when col.get('default'))
