@Learnster.module "ModuleSupplementsApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  class Show.Controller extends App.Controllers.Base

    initialize: (options) ->
      supplementId = if options.supplement instanceof App.Entities
        .ModuleSupplement then options.supplement.get('id') else options.supplement
      @supplement = App.request "module:supplement:entity", supplementId

      @layout = @getLayoutView @supplement

      @listenTo @layout, "show", =>
        @showSupplement(@supplement)
        @showContentsPanel(@supplement)

      @show @layout

    showSupplement: (supplement) ->
      supplementView = @getShowView(supplement)

      # @listenTo supplementView, "edit:supplement:button:clicked", (view) ->
      #   App.vent.trigger "edit:supplement:clicked", view

      @listenTo supplementView, "delete:supplement:button:clicked", (view) ->
        model = view.model
        @showDeleteDialog(model)

      @listenTo supplementView, "cancel:show:supplement:button:clicked", (view) ->
        supplement = view.model
        moduleId = supplement.get('learning_module').id
        App.navigate "/module/#{moduleId}/show"

      @listenTo supplementView, "show", ->
        @showContents(supplement)

      @show supplementView,
        loading:
          loadingType: "spinner"
        region: @layout.supplementRegion

    showContents: (supplement) ->
      @supplementId = supplement.get('id')
      contents = App.request("supplement:content:entities", @supplementId)
      contentsView = @getContentsView(contents)

      @listenTo contentsView, "childview:content:clicked", (child, args) ->
        model = args.model
        App.vent.trigger "wiki:content:clicked", model if model.get('type') is "WikiContent"

      @listenTo contentsView, "childview:content:delete:clicked", (child, args) ->
        model = args.model
        @showDeleteContentDialog(model)

      @show contentsView,
        loading:
          loadingType: "spinner"
        region: @layout.supplementContentsRegion

    showDeleteDialog: (supplement) ->
      dialogView = @getDialogView supplement

      @listenTo dialogView, "dialog:delete:supplement:clicked", =>
        dialogView.$el.modal "hide"
        moduleId = supplement.get('learning_module').id
        supplement.destroy()
        supplement.on "destroy", => App.navigate "/module/#{moduleId}/show"

      @show dialogView,
        loading:
          loadingType: "spinner"
        region: App.dialogRegion

    showDeleteContentDialog: (content) ->
      dialogView = @getContentDialogView content
      @listenTo dialogView, "dialog:delete:supplement:content:clicked", =>
        dialogView.$el.modal "hide"
        content.destroy()
        content.on "destroy", => @showContents(@supplement)

      @show dialogView,
        loading:
          loadingType: "spinner"
        region: App.dialogRegion

    showContentsPanel: (supplement) ->
      panelView = @getPanelView(supplement)

      @listenTo panelView, "new:upload:content:button:clicked", =>
        @showNewUploadRegion()

      @listenTo panelView, "new:wiki:content:button:clicked", =>
        @showNewWikiRegion()

      @show panelView,
        loading:
          loadingType: "spinner"
        region: @layout.supplementContentsPanelRegion

    showNewUploadRegion: ->
      App.execute "new:content:upload:view", @layout.newSupplementContentRegion, @supplementId

    showNewWikiRegion: ->
      App.execute "new:wiki:content:view", @layout.newSupplementContentRegion, @supplementId

    getLayoutView: (supplement) ->
      new Show.Layout
        model: supplement

    getShowView: (supplement) ->
      new Show.Supplement
        model: supplement

    getDialogView: (supplement) ->
      new Show.DeleteDialog
        model: supplement

    getContentDialogView: (content) ->
      new Show.DeleteContentDialog
        model: content

    getPanelView: (supplement) ->
      new Show.Panel
        model: supplement

    getContentsView: (sections) ->
      cols = @getTableColumns()
      options = @getTableOptions cols
      App.request "table:wrapper", sections, options

    getTableColumns: ->
      [
       { title: "Title", attrName: "title", isSortable: true, default: true, isRemovable: false },
       { title: "Created On", attrName: "created_at_formatted", isSortable: true, default: true, isRemovable: false },
       { title: "File", htmlContent: '<% if(model.get("file_upload")){ %><a class="file-link" target="_blank" href="<%= model.get("file_upload").url %>">&#10004;</a><% } %>'
        , isSortable: true, default: true, isRemovable: false },
       { title: "Wiki", htmlContent: '<% if(model.get("wiki_markup")){ %><span class="wiki-link">&#10004;</span><% } %>'
        , isSortable: true, default: true, isRemovable: false },
       { htmlContent: @_deleteColTemplateString(), className: "last-col-invisible"
        ,default: true, isRemovable: false, hasData: false }
      ]

    _deleteColTemplateString: ->
      '<% if ( (currentUser.get("type") === "OrgAdmin" && currentUser.get("role") === "course_manager"
              && model.get("module_supplement").learning_module.educator_id === currentUser.get("id")
        || currentUser.get("type") === "OrgAdmin" && currentUser.get("role") === "module_manager"
              && model.get("module_supplement").learning_module.educator_id === currentUser.get("id") )
        || currentUser.get("type") ===  "AppAdmin" || (currentUser.get("type") === "OrgAdmin"
                                                       && currentUser.get("role") === "account_manager" )) { %>
        <div class="delete-icon"><i class="icon-remove-sign"></i></div>
        <% } %>'

    getTableOptions: (columns) ->
      columns: columns
      region: @layout.supplementContentsRegion
      config:
        spanClass: "span7"
        emptyMessage: "No contents have been set :("
        itemProperties:
          triggers:
              "click .delete-icon i"   : "content:delete:clicked"
              "click"                  : "content:clicked"
          events:
              "click a.file-link" : ((e) => e.stopImmediatePropagation())
