@Learnster.module "SidebarApp.List", (List, App, Backbone, Marionette, $, _) ->

  class List.Controller extends App.Controllers.Base

    initialize: (options) ->
      switch options.type
        when "AppAdmin"        then sideBarItems = @getAppAdminBarItems()
        when "account_manager" then sideBarItems = @getAccountAdminBarItems()
        when "course_manager"  then sideBarItems = @getCourseAdminBarItems()
        when "Student"         then sideBarItems = @getStudentBarItems()
        when "Login"           then sideBarItems = @getLoginBarItems()

      sideItemCollection = App.request "sidebar:entities", sideBarItems
      sideBarView = App.request "tree:wrapper", sideItemCollection

      @listenTo sideBarView, "childview:side:item:link:clicked", (child, args) ->
        user = App.currentUser
        model = child.model
        switch model.get('id')
          when "side-item-sign-in"      then @sideNavTo("login", child)
          when "side-item-sign-up"      then @sideNavTo("signup", child)
          when "side-item-orgs"         then @sideNavTo("organisations",child)
          when "side-item-app-admins"   then @sideNavTo("admins", child)
          when "side-item-app-students" then @sideNavTo("students", child)
          when "side-item-dash"         then @sideNavTo("/organisation/#{@_getOrgId(user)}/dashboard", child)
          when "side-item-all-admins"   then @sideNavTo("/organisation/#{@_getOrgId(user)}/admins", child)
          when "side-item-all-students" then @sideNavTo("/organisation/#{@_getOrgId(user)}/students", child)
          when "side-item-my-students"  then @sideNavTo("/organisation/#{@_getOrgId(user)}/my_students", child)
          when "side-item-my-administrators" then @sideNavTo("/organisation/#{@_getOrgId(user)}/my_admins", child)
          when "side-item-my-courses"   then @sideNavTo("/organisation/#{@_getOrgId(user)}/my_courses", child)
          when "side-item-my-modules"   then @sideNavTo("/organisation/#{@_getOrgId(user)}/my_modules", child)

      @show sideBarView

    sideNavTo: (route, itemView) ->
      App.navigate route
      linkId = itemView.$el.find('a').attr('id')
      App.commands.execute "side:higlight:item", linkId

    getAppAdminBarItems: ->
      [
        { text: "Organisations", id: "side-item-orgs"},
        { text: "Administrators", id: "side-item-app-admins"},
        { text: "Students", id: "side-item-app-students" }
      ]

    getAccountAdminBarItems: ->
      [
        { text: "Dashboard", id: "side-item-dash" },
        { text: "All Administrators", id: "side-item-all-admins"  },
        { text: "All Students", id: "side-item-all-students"  },
        { text: "My Administrators", id: "side-item-my-administrators"  }
        { text: "My Students", id: "side-item-my-students"  }
      ]

    getCourseAdminBarItems: ->
      [
        { text: "Dashboard", id: "side-item-dash" },
        { text: "My Courses", id: "side-item-my-courses"  },
        { text: "My Learning Modules", id: "side-item-my-modules"  },
        { text: "All Administrators", id: "side-item-all-admins"  },
        { text: "All Students", id: "side-item-all-students"  },
      ]

    getStudentBarItems: ->
      [
        { text: "Dashboard"},
        { text: "Educators" },
        { text: "Modules"  }
      ]

    getLoginBarItems: ->
      [
        { text: "Sign in", id: "side-item-sign-in"},
        { text: "Sign up Organisation", id: "side-item-sign-up" }
      ]

    _getOrgId: (user) ->
      id = user.get('admin_for').id if user instanceof App.Entities.OrgAdmin
      id = user.get('attendning_org').id if user instanceof App.Entities.Student
      id
