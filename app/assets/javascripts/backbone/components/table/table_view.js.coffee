@Learnster.module "Components.Table", (Table, App, Backbone, Marionette, $, _) ->

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
            @defaultColumns = @getDefaultColumns @columns.models

            @setInstancePropertiesFor "itemViewOptions"

        onShow: ->
            @drawColumnHeaders @columns.models
            @styleTable @config.tableClassName

        hideColumn: (itemView, filterColumn) ->
            $li = itemView.$el
            $tableCol = @$getTableColumn(filterColumn)
            if filterColumn.get('isRemovable') and filterColumn.get('isShowing')
                filterColumn.set('isShowing', false)
                $li.removeClass('active')
                $tableCol.addClass('hide')


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
            $column[0]

        appendHtml: (collectionView, itemView, index) ->
            if not collectionView.collection.isEmpty()
                $row = itemView.$el
                model = itemView.model
                @drawCell(col, $row, model, itemView, index) for col in @columns.models
                collectionView.$("tbody").append($row[0])
            else
                emptyCell = "<td colspan='#{@columns.models.length}'>#{@config.emptyMessage}</td>"
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

        styleTable: (className) ->
            @ui.table.addClass className

        $getTableColumn: (filterColumn) ->
            console.log filterColumn
            column = @columns.where({ title: filterColumn.get('title') })[0]
            colIndex = @columns.indexOf column

            $(".col-#{colIndex}")

        getDefaultColumns: (columns) ->
            (col for col in columns when col.get('default'))
