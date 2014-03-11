@Learnster.module "Components.List", (List, App, Backbone, Marionette, $, _) ->

  class List.Empty extends App.Views.ItemView
    template: "unordered_list/_empty_item"
    tagName: "li"

  class List.Item extends App.Views.ItemView
    template: "unordered_list/_list_item"
    tagName: "li"
    initialize: (options) ->
      @setInstancePropertiesFor "triggers"

  class List.Wrapper extends App.Views.CompositeView
    template: "unordered_list/list_items"
    itemView: List.Item
    emptyView: List.Empty
    ui:
      list:      "ul#app-list"
      pageArea:   ".pagination-area"

    collectionEvents:
      "reset"   : "render"
      "destroy" : "removeItemView"

    initialize: (options) ->
      { @config } = options
      @collection = options.collection
      @setInstancePropertiesFor "itemViewOptions"
      @bindInfiniteScroll() if @config.isPaginable

    onShow: ->
      @styleList @config.listClassName
      @drawCollectionCount()

    onClose: ->
      $(window).unbind('scroll') if @config.isPaginable

    drawCollectionCount: ->
      @ui.pageArea.first()
        .html("<span class='text-info'>Viewing: #{@collection
          .size()} out of #{@collection.size()} records</span>")

    appendHtml: (collectionView, itemView, index) ->
      if not collectionView.collection.isEmpty()
        $row   = itemView.$el
        model  = itemView.model

        templateObjects = _.extend(Marionette.View.prototype.templateHelpers(), model.attributes)
        markUp = JST[@config.listItemTemplate](templateObjects)

        $row.append(markUp)
        @ui.list.append($row[0])
      else
        emptyCell = "<span>#{@config.emptyMessage}</span>"
        @ui.list.append(emptyCell)

    styleList: (className) ->
      @ui.list.addClass className

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
            params['student_id']           = @collection.get('student_id')  if hasStudiedBy
            params['deliverable_id']       = @collection.get('deliverable_id') if hasDeliverable

            @collection.fetch
              data: $.param(params)

            @collection.on "synced:pagninable:collection", =>
              if @collection.get('next_link') ==  @collection.get('last_link')
                @_finishScroll()

    _finishScroll: ->
      @ui.pageArea.first().removeClass('pagination-loader')
      @drawCollectionCount()

