@Learnster.module "Components.Table", (Table, App, Backbone, Marionette, $, _) ->
    
    class Table.Controller extends App.Controllers.Base
        initialize: (options = {}) ->
            { @collection, config, columns } = options
            @tableView = @getTableView config, columns

        getTableView: (config, columns) ->
            config = @getDefaultConfig config
            cols = @getColumns columns

            new Table.Wrapper
                collection: @collection
                config:     config
                columns:    cols
                itemViewOptions: config.itemProperties 

        getDefaultConfig: (config = {}) ->
            _.defaults config,
                isSearchable:   true
                isPaginable:    true
                emptyMessage:   "No items founds :("
                tableClassName: "table table-bordered tablesorter"

        getColumns: (cols) ->
            App.request("table:column:entities", cols, false)



    App.reqres.setHandler "table:wrapper", (collection, options) ->
        throw new Error "No columns supplied" unless options.columns
        formController = new Table.Controller
            collection: collection
            region:     options.region if options.region
            config:     options.config
            columns:    options.columns
        formController.tableView