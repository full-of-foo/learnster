@Learnster.module "CoursesApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  class Show.Controller extends App.Controllers.Base

    initialize: (options) ->
      id = options.id
      course = App.request "course:entity", id
      @layout = @getLayoutView course

      @listenTo @layout, "show", =>
        @showCourse(course)

      @show @layout

    showCourse: (course) ->
      courseView = @getShowView(course)

      @listenTo courseView, "edit:course:button:clicked", (view) ->
        App.vent.trigger "edit:course:clicked", view

      @listenTo courseView, "delete:course:button:clicked", (view) ->
        model = view.model
        @showDeleteDialog(model)
        
      @listenTo courseView, "show", ->
        courseId = course.get('id')
        orgId = course.get('organisation').id
        courseSections = App.request("course:course_section:entities", orgId, courseId)
        courseSectionsView = @getCourseSectionsView(courseSections)

        @show courseSectionsView,
          loading:
            loadingType: "spinner"
          region: @layout.courseSectionsRegion

      @show courseView,
        loading:
          loadingType: "spinner"
        region: @layout.courseRegion

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

    getLayoutView: (course) ->
      new Show.Layout
        model: course

    getShowView: (course) ->
      new Show.Course
        model: course

    getDialogView: (course) ->
      new Show.DeleteDialog
        model: course

    getCourseSectionsView: (sections) ->
      cols = @getTableColumns()
      options = @getTableOptions cols
      App.request "table:wrapper", sections, options

    getTableColumns: ->
      [
       { title: "Section", attrName: "section", isSortable: true, default: true, isRemovable: false },
       { title: "# Students", htmlContent: '<%= model.get("student_count") %>', default: true,  isSortable: true, isRemovable: false },
       { title: "Provisioner", attrName: "provisioned_by.full_name", isSortable: true, isRemovable: false, default: true },
       { title: "Created On", attrName: "created_at_formatted", isSortable: true, default: true, isRemovable: false },
       { htmlContent: '<% if ( model.get("created_by") && model.get("created_by").id === currentUser.get("id")
        || currentUser.get("type") ===  "AppAdmin" ) { %>
        <div class="delete-icon"><i class="icon-remove-sign"></i></div>
        <% } %>
      ', className: "last-col-invisible", default: true, isRemovable: false, hasData: false }
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
