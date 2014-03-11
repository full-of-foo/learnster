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
      pageArea:   ".pagination-area"

    collectionEvents:
      "reset": "render"
      "destroy": "removeItemView"

    initialize: (options) ->
      { @columns, @config } = options
      @columns = @columns.models
      @collection = options.collection
      @model = new App.Entities.TableConfig(@config)
      @defaultColumns = @getDefaultColumns @columns
      @setInstancePropertiesFor "itemViewOptions"
      @bindInfiniteScroll()  if @config.isPaginable

    onShow: ->
      @drawColumnHeaders @columns
      @styleTable @config.tableClassName
      @drawCollectionCount()

    onClose: ->
      $(window).unbind('scroll') if @config.isPaginable

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

    drawCollectionCount: ->
      @ui.pageArea.first()
        .html("<span class='text-info'>Viewing: #{@collection
          .size()} out of #{@collection.size()} records</span>")

    $setColumnHeader: (column) ->
      colIndex = @columns.indexOf(column)
      $column = if column.get('htmlHeader') then $("<th>" + column
        .get('htmlHeader') + "</th>") else $("<th>" + column.get('title') + "</th>")
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
        attrArray = attr.split /\./
        attrString = if attrArray.length is 1 then model.
          get(attrArray[0]) else model.get(attrArray[0])[attrArray[1]]
        attrString = @_elipTrim(attrString) if((attr is 'description' or attr is 'notes') and attrString)

        $row.append($cell.append(attrString))

      if col.get('htmlContent')
        user = App.request "get:current:user"
        t = _.template(col.get('htmlContent'), { model : model, currentUser: user })
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

    bindInfiniteScroll: =>
      pageNumber = 1

      App.execute "when:fetched", @collection, =>
        @_setScrollableCollection(pageNumber)

    _setScrollableCollection: (pageNumber) ->

      $(window).scroll =>
        if @collection.get('next_link')
          @ui.pageArea.first().html('')

          if (Number(@collection.get('next_link')) == pageNumber + 1) and ($(window)
              .scrollTop() > $(document).height() - $(window).height() - 50)
            pageNumber += 1
            @ui.pageArea.first().addClass('pagination-loader')

            hasCreatedBy        = @collection.get('created_by')
            hasManagedBy        = @collection.get('managed_by')
            hasEducatedBy       = @collection.get('educator_id')
            hasParentSupplement = @collection.get('module_supplement_id')
            hasStudiedBy        = @collection.get('student_id')
            hasDeliverable      = @collection.get('deliverable_id')

            params =
              page:       @collection.get('next_link')
              search:     @collection.get('search')

            params['created_by']           = @collection.get('created_by')  if hasCreatedBy
            params['managed_by']           = @collection.get('managed_by')  if hasManagedBy
            params['educator_id']          = @collection.get('educator_id') if hasEducatedBy
            params['module_supplement_id'] = @collection.get('module_supplement_id') if hasParentSupplement
            params['student_id']           = @collection.get('student_id')     if hasStudiedBy
            params['deliverable_id']       = @collection.get('deliverable_id') if hasDeliverable

            @collection.fetch
              data: $.param(params)

            @collection.on "synced:pagninable:collection", =>
              if @collection.get('next_link') ==  @collection.get('last_link')
                @_finishScroll()

    _finishScroll: ->
      @ui.pageArea.first().removeClass('pagination-loader')
      @drawCollectionCount()

    _elipTrim: (string, maxSize = 30) ->
      if string.length >= maxSize then string.trimRight().substring(0, maxSize) + "..." else string

