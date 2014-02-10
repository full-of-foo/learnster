@Learnster.module "CourseSectionsApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  class Show.Controller extends App.Controllers.Base

    initialize: (options) ->
      id = options.id
      courseSection = App.request "course_section:entity", id
      @layout = @getLayoutView courseSection

      @listenTo @layout, "show", =>
        @showCourseSection(courseSection)
        @showModulePanel(courseSection)

      @show @layout

    showCourseSection: (courseSection) ->
      courseSectionView = @getShowView(courseSection)

      @listenTo courseSectionView, "edit:course_section:button:clicked", (view) ->
        App.vent.trigger "edit:course_section:clicked", view

      @listenTo courseSectionView, "delete:course_section:button:clicked", (view) ->
        model = view.model
        @showDeleteDialog(model)

      @listenTo courseSectionView, "show", ->
        @showModules(courseSection)

      @show courseSectionView,
        loading:
          loadingType: "spinner"
        region: @layout.courseSectionRegion

    showModules: (courseSection) ->
      @courseSectionId = courseSection.get('id')
      modules = App.request("section:learning_module:entities", @courseSectionId)
      modulesView = @getModulesView(modules)

      @show modulesView,
        loading:
          loadingType: "spinner"
        region: @layout.modulesRegion

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

      @listenTo panelView, "new:module:button:clicked", =>
        courseId = courseSection.get('course').id
        @showNewRegion(courseId)

      @show panelView,
        loading:
          loadingType: "spinner"
        region: @layout.modulePanelRegion

    showNewRegion: (courseId) ->
      @layout.addModuleRegion['_nestingCourseId'] = courseId
      App.execute "add:module:view", @layout.addModuleRegion, @courseSectionId

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

    getModulesView: (modules) ->
      cols = @getTableColumns()
      options = @getTableOptions cols
      App.request "table:wrapper", modules, options

    getTableColumns: ->
      [
       { title: "Title", attrName: "title", isSortable: true, default: true, isRemovable: false },
       { title: "Description", attrName: "description", default: true },
       { title: "Educator", attrName: "educator.full_name", isSortable: true, isRemovable: false, default: true },
       { title: "Created On", attrName: "created_at_formatted", isSortable: true, default: true, isRemovable: false }
      ]

    getTableOptions: (columns) ->
      columns: columns
      region: @layout.courseSectionsRegion
      config:
        emptyMessage: "No modules added :("
        itemProperties:
          triggers:
              "click .delete-icon i"   : "module:delete:clicked"
              "click"                  : "module:clicked"
