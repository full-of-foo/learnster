@Learnster.module "LearningModulesApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  class Show.Controller extends App.Controllers.Base

    initialize: (options) ->
      @moduleId = options.id
      @supplementId = options.supplementId if options.supplementId
      module = App.request "learning_module:entity", @moduleId

      @layout = @getLayoutView module

      @listenTo @layout, "show", =>
        @showModule(module)
        @showPanel(module)
        @showSupplements(module)
        @showSupplementRegion(@supplementId) if @supplementId

      @show @layout

    showModule: (module) ->
      moduleView = @getShowView(module)

      @listenTo moduleView, "edit:module:button:clicked", (view) ->
        App.vent.trigger "edit:module:clicked", view

      @listenTo moduleView, "delete:module:button:clicked", (view) ->
        model = view.model
        @showDeleteDialog(model)

      @show moduleView,
        loading:
          loadingType: "spinner"
        region: @layout.moduleRegion

    showPanel: (module) ->
      panelView = @getPanelView(module)

      @listenTo panelView, "add:module:supplement:button:clicked", =>
        @showNewRegion(module)

      @show panelView,
        loading:
          loadingType: "spinner"
        region: @layout.panelRegion

    showSupplements: (module) ->
      @moduleId = module.get('id')
      supplements = App.request("module:supplement:entities", @moduleId)
      supplementsView = @getSupplementsView(supplements)

      @listenTo supplementsView, "childview:supplement:clicked", (child, args) ->
        console.log args
        supplement = args.model
        moduleId = supplement.get('learning_module').id
        supplementId = supplement.get('id')
        App.navigate "/module/#{moduleId}/supplement/#{supplementId}/show"

      @listenTo supplementsView, "childview:supplement:delete:clicked", (child, args) ->
        @showDeleteSupplementDialog(args.model)

      @show supplementsView,
        loading:
          loadingType: "spinner"
        region: @layout.supplementsRegion


    showDeleteDialog: (module) ->
      dialogView = @getDialogView module

      @listenTo dialogView, "dialog:delete:module:clicked", =>
        orgId = module.get('organisation_id')
        dialogView.$el.modal "hide"
        module.destroy()
        module.on "destroy", -> App.navigate "/organisation/#{orgId}/modules"

      @show dialogView,
        loading:
          loadingType: "spinner"
        region: App.dialogRegion

    showDeleteSupplementDialog: (supplement) ->
      dialogView = @getSupplementDialogView supplement

      @listenTo dialogView, "dialog:delete:supplement:clicked", =>
        dialogView.$el.modal "hide"
        supplement.destroy()
        supplement.on "destroy", => App.navigate "/module/#{@moduleId}/show"

      @show dialogView,
        loading:
          loadingType: "spinner"
        region: App.dialogRegion

    showNewRegion: (module) ->
      App.execute "new:supplement:view", @layout.supplementRegion, module.get('id')

    showSupplementRegion: (supplement) ->
      App.execute "show:supplement:view", @layout.supplementRegion, supplement

    getLayoutView: (module) ->
      new Show.Layout
        model: module

    getShowView: (module) ->
      new Show.Module
        model: module

    getDialogView: (module) ->
      new Show.DeleteDialog
        model: module

    getSupplementDialogView: (supplement) ->
      new Show.DeleteSupplementDialog
        model: supplement

    getPanelView: (module) ->
      new Show.Panel
        model: module

    getSupplementsView: (supplements) ->
      cols = @getTableColumns()
      options = @getTableOptions cols
      App.request "table:wrapper", supplements, options

    getTableColumns: ->
      [
       { title: "Title", attrName: "title", isSortable: true, default: true, isRemovable: false },
       { title: "Description", attrName: "description",  isSortable: true, default: true, isRemovable: false },
       { title: "# Contents", attrName: "contents_counts",  isSortable: true, default: true, isRemovable: false },
       { htmlContent: @_deleteColTemplateString(), className: "last-col-invisible", default: true, isRemovable: false, hasData: false }
      ]

    _deleteColTemplateString: ->
      '<% if ( (currentUser.get("type") === "OrgAdmin" && currentUser.get("role") === "course_manager"
              && model.get("learning_module").educator_id === currentUser.get("id")
              || currentUser.get("type") === "OrgAdmin" && currentUser.get("role") === "module_manager"
              && model.get("learning_module").educator_id === currentUser.get("id") )
        || currentUser.get("type") ===  "AppAdmin" || (currentUser.get("type") === "OrgAdmin"
                                                       && currentUser.get("role") === "account_manager" )) { %>
        <div class="delete-icon"><i class="icon-remove-sign"></i></div>
        <% } %>'

    getTableOptions: (columns) ->
      columns: columns
      region: @layout.supplementsRegion
      config:
        emptyMessage: "No supplements added :("
        itemProperties:
          triggers:
              "click .delete-icon i"   : "supplement:delete:clicked"
              "click"                  : "supplement:clicked"
