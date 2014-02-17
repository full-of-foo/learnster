@Learnster.module "CoursesApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  class Show.Controller extends App.Controllers.Base

    initialize: (options) ->
      id = options.id
      @course = App.request "course:entity", id
      @layout = @getLayoutView @course

      @listenTo @layout, "show", =>
        @showCourse(@course)
        @showSectionPanel(@course)

      @show @layout

    showCourse: (course) ->
      courseView = @getShowView(course)

      @listenTo courseView, "edit:course:button:clicked", (view) ->
        App.vent.trigger "edit:course:clicked", view

      @listenTo courseView, "delete:course:button:clicked", (view) ->
        model = view.model
        @showDeleteDialog(model)

      @listenTo courseView, "show", ->
        @showCourseSections(course)

      @show courseView,
        loading:
          loadingType: "spinner"
        region: @layout.courseRegion

    showCourseSections: (course) ->
      @courseId = course.get('id')
      orgId = course.get('organisation').id
      courseSections = App.request("course:course_section:entities", orgId, @courseId)
      courseSectionsView = @getCourseSectionsView(courseSections)

      @listenTo courseSectionsView, "childview:course_section:clicked", (child, args) ->
        App.vent.trigger "course_section:clicked", args.model

      @listenTo courseSectionsView, "childview:course_section:delete:clicked", (child, args) ->
        model = args.model
        @showDeleteSectionDialog(model)

      @show courseSectionsView,
        loading:
          loadingType: "spinner"
        region: @layout.courseSectionsRegion

    showDeleteDialog: (course) ->
      dialogView = @getDialogView course

      @listenTo dialogView, "dialog:delete:course:clicked", =>
        orgId = course.get('organisation').id
        dialogView.$el.modal "hide"
        course.destroy()
        course.on "destroy", -> App.navigate "organisation/#{orgId}/courses"

      @show dialogView,
        loading:
          loadingType: "spinner"
        region: App.dialogRegion

    showDeleteSectionDialog: (courseSection) ->
      dialogView = @getSectionDialogView courseSection
      @listenTo dialogView, "dialog:delete:course_section:clicked", =>
        dialogView.$el.modal "hide"
        courseSection.destroy()
        courseSection.on "destroy", => @showCourseSections(@course)

      @show dialogView,
        loading:
          loadingType: "spinner"
        region: App.dialogRegion

    showSectionPanel: (course) ->
      panelView = @getPanelView(course)

      @listenTo panelView, "new:course:section:button:clicked", =>
        orgId = course.get('organisation').id
        @showNewRegion(orgId)

      @show panelView,
        loading:
          loadingType: "spinner"
        region: @layout.courseSectionPanelRegion

    showNewRegion: (orgId) ->
      @layout.newCourseSectionRegion['_nestingOrgId'] = orgId
      App.execute "new:course:section:view", @layout.newCourseSectionRegion, @courseId

    getLayoutView: (course) ->
      new Show.Layout
        model: course

    getShowView: (course) ->
      new Show.Course
        model: course

    getDialogView: (course) ->
      new Show.DeleteDialog
        model: course

    getSectionDialogView: (courseSection) ->
      new App.CourseSectionsApp.Show.DeleteDialog
        model: courseSection

    getPanelView: (course) ->
      new Show.Panel
        model: course

    getCourseSectionsView: (sections) ->
      cols = @getTableColumns()
      options = @getTableOptions cols
      App.request "table:wrapper", sections, options

    getTableColumns: ->
      [
       { title: "Section", attrName: "section", isSortable: true, default: true, isRemovable: false },
       { title: "# Students", htmlContent: '<%= model.get("student_count") %>', default: true,  isSortable: true, isRemovable: false },
       { title: "# Modules", htmlContent: '<%= model.get("module_count") %>', default: true,  isSortable: true, isRemovable: false },
       { title: "Provisioner", attrName: "provisioned_by.full_name", isSortable: true, isRemovable: false, default: true },
       { title: "Created On", attrName: "created_at_formatted", isSortable: true, default: true, isRemovable: false },
       { htmlContent: '<div class="delete-icon"><i class="icon-remove-sign"></i></div>', className: "last-col-invisible", default: true, isRemovable: false, hasData: false }
      ]

    getTableOptions: (columns) ->
      columns: columns
      region: @layout.courseSectionsRegion
      config:
        emptyMessage: "No course sections exist :("
        itemProperties:
          triggers:
              "click .delete-icon i"   : "course_section:delete:clicked"
              "click"                  : "course_section:clicked"
