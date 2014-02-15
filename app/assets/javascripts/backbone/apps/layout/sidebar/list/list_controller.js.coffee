@Learnster.module "SidebarApp.List", (List, App, Backbone, Marionette, $, _) ->

  class List.Controller extends App.Controllers.Base

    initialize: (options) ->
      switch options.type
        when "AppAdmin" then sideBarItems = @getAppAdminBarItems()
        when "OrgAdmin" then sideBarItems = @getOrgAdminBarItems()
        when "Student" then sideBarItems = @getStudentBarItems()
        when "Login" then sideBarItems = @getLoginBarItems()

      sideItemCollection = App.request "sidebar:entities", sideBarItems
      sideBarView = App.request "tree:wrapper", sideItemCollection

      @listenTo sideBarView, "childview:side:item:link:clicked", (child, args) ->
        model = child.model
        switch model.get('id')
          when "side-item-sign-in" then @sideNavToSignIn(child)
          when "side-item-sign-up" then @sideNavToSignUp(child)

      @show sideBarView

    navToSignIn: ->
      @_removeAllSideItemHighlights()
      @_addHighlightToElem "side-item-sign-in"

    sideNavToSignIn: (itemView) ->
      App.navigate "/login"
      @navToSignIn()

    navToSignUp: ->
      @_removeAllSideItemHighlights()
      @_addHighlightToElem "side-item-sign-up"

    sideNavToSignUp: (itemView) ->
      App.navigate "/signup"
      @navToSignUp()

    getAppAdminBarItems: ->
      [
        { text: "Students", default:  true },
        { text: "Org Admins"      },
        { text: "Organisations"   }
      ]

    getOrgAdminBarItems: ->
      [
        { text: "Dashboard", default:  true },
        { text: "My Students" },
        { text: "Org Admins"  },
        { text: "My Admins"   }
      ]

    getStudentBarItems: ->
      [
        { text: "Dashboard", default:  true },
        { text: "Educators" },
        { text: "Modules"  }
      ]

    getLoginBarItems: ->
      [
        { text: "Sign in", id: "side-item-sign-in", default:  true },
        { text: "Sign up Organisation", id: "side-item-sign-up" }
      ]

    _addHighlightToElem: (elemIdStr) ->
      $("##{elemIdStr}").parent().addClass('active')

    _removeAllSideItemHighlights: ->
      App.commands.execute "clear:sidebar:higlight"
