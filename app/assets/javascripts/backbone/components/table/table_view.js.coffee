@Learnster.module "Components.Table", (Table, App, Backbone, Marionette, $, _) ->

    class Table.Empty extends App.Views.ItemView
        template: "table/_empty_item"
        tagName: "tr"
        initialize: -> console.log @el

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
            @setInstancePropertiesFor "itemViewOptions"

        onShow: ->
            @drawColumnHeaders @columns
            @styleTable @config.tableClassName


        drawColumnHeaders: (columns) ->
            @drawHeader(column) for column in columns.models
            @ui.table.tablesorter()

        drawHeader: (column) ->
            $column = @$setColumn column
            @ui.headerRow.append($column)

        $setColumn: (column) ->
            $column = if column.get('htmlHeader') then $("<th>" + column.get('htmlHeader') + "</th>") else $("<th>" + column.get('title') + "</th>")
            $column.addClass "{sorter: false}" if not column.get('isSortable')
            $column.addClass column.get('className') if column.get('className')
            $column[0]

        appendHtml: (collectionView, itemView, index) ->
            if not collectionView.collection.isEmpty()
                $row = itemView.$el
                model = itemView.model
                @drawCell(col, $row, model, itemView) for col in @columns.models
                collectionView.$("tbody").append($row[0])
            else
                emptyCell = "<td colspan='#{@columns.models.length}'>#{@config.emptyMessage}</td>"
                collectionView.$("tbody").append(emptyCell)

        drawCell: (col, $row, model, itemView) ->
            $cell = $("<td></td>")
            if col.get('className')
                $cell.addClass(col.get('className'))
            if col.get('attrName')
                attr = col.get('attrName')
                return $row.append($cell.append(model.get(attr)))
            if col.get('htmlContent')
                t = _.template(col.get('htmlContent'), { model : model })
                $row.append($cell.append(t))

        styleTable: (className) ->
            @ui.table.addClass className






