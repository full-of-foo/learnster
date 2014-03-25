@Learnster.module "DeliverablesApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  class Show.Controller extends App.Controllers.Base

    initialize: (options) ->
      @deliverableId = if options.id instanceof App.Entities.Deliverable then options.
        id.get('id') else options.id
      @deliverable = App.request "deliverable:entity", @deliverableId

      @layout = @getLayoutView @deliverable

      @listenTo @layout, "show", =>
        @showDeliverable(@deliverable)

      @show @layout,
        loading:
          loadingType: "spinner"

    showDeliverable: (deliverable) ->
      deliverableView = @getShowView(deliverable)

      @listenTo deliverableView, "delete:deliverable:button:clicked", (view) ->
        model = view.model
        @showDeleteDeliverableDialog(model)

      @listenTo deliverableView, "edit:deliverable:button:clicked", (view) ->
        model = view.model
        App.navigate "/deliverable/#{model.get('id')}/edit"

      @listenTo deliverableView, "cancel:show:deliverable:button:clicked", (view) ->
        deliverable = view.model
        moduleId = deliverable.get('learning_module').id
        App.navigate "/module/#{moduleId}/show"

      @listenTo deliverableView, "show", =>
        @showPanel(deliverable)
        @showSubmissions(deliverable)

      @show deliverableView,
        loading:
          loadingType: "spinner"
        region: @layout.deliverableRegion

    showSubmissions: (deliverable) ->
      @deliverableId = deliverable.get('id')

      submissions = @getSubmissions(deliverable)
      submissionsView = @getSubmissionsView(submissions)

      @listenTo submissionsView, "childview:submission:clicked", (child, args) ->
        model = args.model
        App.vent.trigger "submission:clicked", model if model.get('type') is "WikiSubmission"

      @show submissionsView,
        loading:
          loadingType: "spinner"
        region: @layout.listRegion

    getSubmissions: (deliverable) ->
      user = App.currentUser
      if user.get("type") is "OrgAdmin" or (user.get("type") is "Student" and deliverable
          .get("is_private") is false)
        submissions = App.request("submission:entities", @deliverableId)
      else if user.get("type") is "Student" and deliverable.get("is_private") is true
        submissions = App.request("student:deliverable:submission:entities", @deliverableId, user.get('id'))
      submissions

    showPanel: (deliverable) ->
      panelView = @getPanelView deliverable

      @listenTo panelView, "new:upload:submission:button:clicked", =>
        @showNewUploadRegion()

      @listenTo panelView, "new:wiki:submission:button:clicked", =>
        @showNewWikiRegion()

      @show panelView,
        loading:
          loadingType: "spinner"
        region: @layout.panelRegion

    showDeleteDeliverableDialog: (deliverable) ->
      dialogView = @getDeliverableDialogView deliverable
      @listenTo dialogView, "dialog:delete:deliverable:clicked", =>
        dialogView.$el.modal "hide"
        moduleId     = deliverable.get('module_supplement').learning_module.id
        supplementId =  deliverable.get('module_supplement').id
        deliverable.destroy()
        deliverable.on "destroy", => App.navigate "/module/#{moduleId}/supplement/#{supplementId}/show"

      @show dialogView,
        loading:
          loadingType: "spinner"
        region: App.dialogRegion

    getLayoutView: (deliverable) ->
      new Show.Layout
        model: deliverable

    getShowView: (deliverable) ->
      new Show.Deliverable
        model: deliverable

    getPanelView: (deliverable) ->
      new Show.Panel
        model: deliverable

    getDeliverableDialogView: (deliverable) ->
      new Show.DeleteDeliverableDialog
        model: deliverable

    getSubmissionsView: (submissions) ->
      cols = @getTableColumns()
      options = @getTableOptions cols
      App.request "table:wrapper", submissions, options

    showNewUploadRegion: ->
      App.execute "new:submission:upload:view", @layout.newRegion, @deliverableId

    showNewWikiRegion: ->
      App.execute "new:wiki:submission:view", @layout.newRegion, @deliverableId

    getTableColumns: ->
      [
       { title: "Student", attrName: 'student.full_name', isSortable: true, default: true, isRemovable: false },
       { title: "Notes",  attrName: 'notes', default: true,  isSortable: true, isRemovable: false },
       { title: "File", htmlContent: '<% if(model.get("file_upload")){ %><a class="file-link" target="_blank" href="<%= model.get("file_upload").url %>">&#10004;</a><% } %>'
        , isSortable: true, default: true, isRemovable: false },
       { title: "Wiki", htmlContent: '<% if(model.get("wiki_markup")){ %><span class="wiki-link">&#10004;</span><% } %>'
        , isSortable: true, default: true, isRemovable: false },
       { title: "Submitted On", attrName: "created_at_formatted", isSortable: true, default: true, isRemovable: false }
      ]

    _deleteColTemplateString: ->
      '<% if ( (currentUser.get("type") === "OrgAdmin" && currentUser.get("role") === "course_manager"
              && model.get("deliverable").module_supplement.learning_module.educator_id === currentUser.get("id")
        || currentUser.get("type") === "OrgAdmin" && currentUser.get("role") === "module_manager"
              && model.get("deliverable").module_supplement.learning_module.educator_id === currentUser.get("id") )
        || currentUser.get("type") ===  "AppAdmin" || (currentUser.get("type") === "OrgAdmin"
                                                       && currentUser.get("role") === "account_manager" )) { %>
        <div class="delete-icon"><i class="icon-remove-sign"></i></div>
        <% } %>'

    getTableOptions: (columns) ->
      columns: columns
      region: @layout.listRegion
      config:
        spanClass: "span"
        emptyMessage: "No submissions have been made :("
        itemProperties:
          triggers:
              "click .delete-icon i"   : "submission:delete:clicked"
              "click"                  : "submission:clicked"
          events:
              "click a.file-link" : ((e) => e.stopImmediatePropagation())
