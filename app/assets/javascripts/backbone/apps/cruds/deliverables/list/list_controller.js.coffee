@Learnster.module "DeliverablesApp.List", (List, App, Backbone, Marionette, $, _) ->

  class List.Controller extends App.Controllers.Base

    initialize: (options) ->
      @_nestingOrgId = if options.id then options.id else false

      App.execute "when:fetched", App.currentUser, =>
        deliverables = @getDeliverables()
        @layout = @getLayoutView()

        @listenTo @layout, "show", =>
          @showPanel deliverables
          @showDeliverables deliverables

        @show @layout

    getDeliverables: ->
      user = App.currentUser
      if(user.get('type') is "OrgAdmin")
        deliverables = App.request("educator:deliverable:entities", user.get('id'))
      else if(user.get('type') is "Student")
        deliverables = App.request("student:deliverable:entities", user.get('id'))
      deliverables

    showPanel: (deliverables) ->
      panelView = @getPanelView deliverables
      @show panelView,
        loading:
          loadingType: "spinner"
        region:  @layout.panelRegion

    showDeliverables: (deliverables) ->
      cols = @getTableColumns()
      options = @getTableOptions cols
      @deliverablesView = App.request "table:wrapper", deliverables, options

      @listenTo @deliverablesView, "childview:deliverable:clicked", (child, args) ->
        App.request "show:deliverable", args.model

      @show @deliverablesView,
        loading:
          loadingType: "spinner"
        region: @layout.listRegion

    getPanelView: (deliverables) ->
      new List.Panel
        collection: deliverables

    getLayoutView: ->
      new List.Layout

    getTableColumns: ->
      [
       { title: "Module", htmlContent: '<%= model.get("module_supplement").learning_module.title %>', isSortable: true
        , default: true, isRemovable: false },
       { title: "Supplement", htmlContent: '<%= model.get("module_supplement").title %>', isSortable: true, default: true
        , isRemovable: false },
       { title: "Title", attrName: "title", isSortable: true, default: true, isRemovable: false },
       { title: "Private", htmlContent: '<% if(model.get("is_private")){ %>&#10004;<% } else { %>✘<% } %>'
        , isSortable: true, default: true, isRemovable: false },
       { title: "Due Date", attrName: "due_date_formatted", isSortable: true, default: true, isRemovable: false },
       { title: "Created On", attrName: "created_at_formatted", isSortable: true, default: true, isRemovable: false }
      ]

    getTableOptions: (columns) ->
      columns: columns
      region: @layout.listRegion
      config:
        emptyMessage: "No deliverables have been set :("
        itemProperties:
          triggers:
              "click" : "deliverable:clicked"
