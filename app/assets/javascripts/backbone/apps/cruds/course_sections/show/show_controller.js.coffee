@Learnster.module "CourseSectionsApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  class Show.Controller extends App.Controllers.Base

    initialize: (options) ->
      id = options.id
      @defaultTab = options.tab
      @courseSection = App.request "course_section:entity", id
      @layout = @getLayoutView @courseSection

      @listenTo @layout, "show", =>
        @showCourseSection(@courseSection)

      @listenTo @layout, "modules:tab:clicked", ->
        @showModulesTab(@courseSection)

      @listenTo @layout, "students:tab:clicked", ->
        @showStudentsTab(@courseSection)

      @show @layout

    showCourseSection: (courseSection) ->
      courseSectionView = @getShowView(courseSection)

      @listenTo courseSectionView, "edit:course_section:button:clicked", (view) ->
        App.vent.trigger "edit:course_section:clicked", view

      @listenTo courseSectionView, "delete:course_section:button:clicked", (view) ->
        model = view.model
        @showDeleteDialog(model)

      @listenTo courseSectionView, "show", ->
        if @defaultTab is "modules"
          @showModulesTab(courseSection)
        else
          @showStudentsTab(courseSection)

      @show courseSectionView,
        loading:
          loadingType: "spinner"
        region: @layout.courseSectionRegion

    showModules: (courseSection) ->
      @_closeNewRegion()
      @courseSectionId = courseSection.get('id')
      modules = App.request("section:learning_module:entities", @courseSectionId)
      modulesView = @getModulesView(modules)

      @listenTo modulesView, "childview:module:clicked", (child, args) ->
        App.vent.trigger "module:clicked", args.model

      @show modulesView,
        loading:
          loadingType: "spinner"
        region: @layout.listRegion

    showStudents: (courseSection) ->
      @_closeNewRegion()
      @courseSectionId = courseSection.get('id')
      students = App.request("section:student:entities", @courseSectionId)
      studentsView = @getStudentsView(students)

      @listenTo studentsView, "childview:student:clicked", (child, args) ->
        App.vent.trigger "student:clicked", args.model

      @show studentsView,
        loading:
          loadingType: "spinner"
        region: @layout.listRegion


    showDeleteDialog: (courseSection) ->
      dialogView = @getDialogView courseSection

      @listenTo dialogView, "dialog:delete:course_section:clicked", =>
        courseId = courseSection.get('course').id
        dialogView.$el.modal "hide"
        courseSection.destroy()
        courseSection.on "destroy", -> App.navigate "/course/#{courseId}/show"

      @show dialogView,
        loading:
          loadingType: "spinner"
        region: App.dialogRegion

    showModulePanel: (courseSection) ->
      panelView = @getPanelView(courseSection)

      @listenTo panelView, "add:module:button:clicked", =>
        orgId = courseSection.get('course').organisation_id
        @showNewRegion(orgId, @courseSectionId)

      @listenTo panelView, "remove:module:button:clicked", =>
        orgId = courseSection.get('course').organisation_id
        @showRemoveRegion(orgId, @courseSectionId)

      @show panelView,
        loading:
          loadingType: "spinner"
        region: @layout.panelRegion

    showStudentPanel: (courseSection) ->
      panelView = @getStudentPanelView(courseSection)

      @listenTo panelView, "add:student:button:clicked", =>
        orgId = courseSection.get('course').organisation_id
        @showStudentNewRegion(orgId, @courseSectionId)

      @listenTo panelView, "remove:student:button:clicked", =>
        orgId = courseSection.get('course').organisation_id
        @showStudentRemoveRegion(orgId, @courseSectionId)

      @show panelView,
        loading:
          loadingType: "spinner"
        region: @layout.panelRegion


    showNewRegion: (orgId, courseSectionId) ->
      @layout.addRegion['_nestingOrgId'] = orgId
      @layout.addRegion['_nestingCourseSectionId'] = courseSectionId
      App.execute "new:section:module:view", @layout.addRegion, orgId, courseSectionId

    showRemoveRegion: (orgId, courseSectionId) ->
      @layout.addRegion['_nestingOrgId'] = orgId
      @layout.addRegion['_nestingCourseSectionId'] = courseSectionId
      App.execute "remove:section:module:view", @layout.addRegion, orgId, courseSectionId

    showStudentNewRegion: (orgId, courseSectionId) ->
      @layout.addRegion['_nestingOrgId'] = orgId
      @layout.addRegion['_nestingCourseSectionId'] = courseSectionId
      App.execute "add:student:view", @layout.addRegion, orgId, courseSectionId

    showStudentRemoveRegion: (orgId, courseSectionId) ->
      @layout.addRegion['_nestingOrgId'] = orgId
      @layout.addRegion['_nestingCourseSectionId'] = courseSectionId
      App.execute "remove:student:view", @layout.addRegion, orgId, courseSectionId

    showModulesTab: (courseSection) ->
      $('#course-setction-tab-list a:first').tab('show')
      @showModulePanel(courseSection)
      @showModules(courseSection)

    showStudentsTab: (courseSection) ->
      $('#course-setction-tab-list a:last').tab('show')
      @showStudentPanel(courseSection)
      @showStudents(courseSection)

    getLayoutView: (courseSection) ->
      new Show.Layout
        model: courseSection

    getShowView: (courseSection) ->
      new Show.CourseSection
        model: courseSection

    getDialogView: (courseSection) ->
      new Show.DeleteDialog
        model: courseSection

    getPanelView: (courseSection) ->
      new Show.Panel
        model: courseSection

    getStudentPanelView: (courseSection) ->
      new Show.StudentPanel
        model: courseSection

    getModulesView: (modules) ->
      cols = @getTableColumns()
      options = @getTableOptions cols
      App.request "table:wrapper", modules, options

    getStudentsView: (students) ->
      cols = @getStudentTableColumns()
      options = @getStudentTableOptions cols
      App.request "table:wrapper", students, options

    getTableColumns: ->
      [
       { title: "Title", attrName: "title", isSortable: true, default: true, isRemovable: false },
       { title: "Description", attrName: "description", default: true },
       { title: "Educator", attrName: "educator.full_name", isSortable: true, isRemovable: false, default: true },
       { title: "Created On", attrName: "created_at_formatted", isSortable: true, default: true, isRemovable: false }
      ]

    getTableOptions: (columns) ->
      columns: columns
      region: @layout.listRegion
      config:
        spanClass: "span"
        emptyMessage: "No modules added :("
        itemProperties:
          triggers:
              "click .delete-icon i"   : "module:delete:clicked"
              "click"                  : "module:clicked"

    getStudentTableColumns: ->
      [
       { title: "Name", htmlContent: '<% if ( model.get("is_active") )
          { %><i class="icon-list-online-status" title="Online"></i>
          <% } else { %><i class="icon-list-offline-status" title="Offline"></i>
          <% } %><%= model.get("full_name") %>', isSortable: true, default: true, isRemovable: false }
       { title: "Email", attrName: "email", isSortable: true, default: true, isRemovable: false },
       { title: "Last Online", attrName: "last_login_formatted", isSortable: true, default: true, isRemovable: false },
       { title: "Created On", attrName: "created_at_formatted", isSortable: true, default: true, isRemovable: false }
      ]

    getStudentTableOptions: (columns) ->
      columns: columns
      region: @layout.listRegion
      config:
        spanClass: "span"
        emptyMessage: "No students added :("
        itemProperties:
          triggers:
              "click" : "student:clicked"

    _closeNewRegion: ->
      @layout.addRegion.close()
