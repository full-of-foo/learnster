@Learnster.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

    class Entities.Column extends Entities.Models

    class Entities.ColumnCollection extends Entities.Collections
        model: Entities.Column


    API = 
        getTableColumns: (columns, model) ->
            cols = @getDefaultColumns columns
            new Entities.ColumnCollection(cols)


        getDefaultColumns: (columns) ->
            cols = []
            cols.push(@getDefaultColumn(col)) for col in columns
            cols

        getDefaultColumn: (column) ->
            _.defaults column, 
                isSortable:     false
                title:          "" 
                attrName:       false            
                htmlHeader:     false
                htmlContent:    false 
                className:      false
                default:        false
                isShowing:      true if column.default
                isRemovable:    true


    App.reqres.setHandler "table:column:entities", (columns, model = null) ->
        API.getTableColumns columns, model