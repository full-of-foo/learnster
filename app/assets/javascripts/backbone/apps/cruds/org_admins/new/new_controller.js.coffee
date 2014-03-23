@Learnster.module "OrgAdminsApp.New", (New, App, Backbone, Marionette, $, _) ->

  class New.Controller extends App.Controllers.Base

    initialize: (options = {}) ->
      @_nestingOrg = options.region?._nestingOrg

      org_admin = App.request "new:org_admin:entity"
      @layout = @getLayoutView org_admin

      @listenTo org_admin, "created", ->
        App.vent.trigger "org_admin:created", org_admin

      @listenTo @layout, "show", =>
        @setFormRegion org_admin

      @show @layout


    getLayoutView: (org_admin) ->
      new New.Layout
        model: org_admin

    getNewView: (org_admin) ->
      new New.View
        model: org_admin

    setFormRegion: (org_admin) ->
      @newView = @getNewView org_admin
      formView = App.request "form:wrapper", @newView,
        toast:
          message: "administrator created"

      @listenTo @newView, "show", ->
        @setRoleSelector(org_admin)

      if App.currentUser.get('type') is "AppAdmin"
        @listenTo @newView, "show", ->
          @setOrgSelector()

      @listenTo @newView, "form:cancel", =>
        @region.close()

      @layout.formRegion.show formView

    setRoleSelector: (org_admin) ->
      roles = App.request "role:entities"

      selectView = App.request "selects:wrapper",
        collection: roles
        itemViewId: "formatted_role"
        itemView:   App.Components.Selects.RoleOption

      @listenTo selectView, "show", ->
        @org_admin = org_admin
        _.delay(( => @_bindSelectChange()) , 400)

      @listenTo selectView, "close", ->
        $('select#formatted_role').unbind('change')

      @show selectView,
        loading:
          loadingType: "spinner"
        region:  @newView.roleSelectRegion


    setOrgSelector: ->
      if @_nestingOrg
        orgs = App.request("new:org:entities")
        orgs.push(@_nestingOrg)
      else
        orgs = App.request("org:entities")

      selectView = App.request "selects:wrapper",
        collection: orgs
        itemViewId: "admin_for"
        itemView:   App.Components.Selects.OrgOption
      @show selectView,
        loading:
            loadingType: "spinner"
        region:  @newView.orgSelectRegion

    _bindSelectChange: ->
      defaultVal = $('.selectpicker').selectpicker('val')
      camelVal   = $("select option:contains('#{defaultVal}')").attr('data-camel-value')
      @org_admin.set('role', camelVal)

      $('select#formatted_role').on 'change', =>
          dropDownValue = $("#role-select-region .filter-option").text().trim()
          camelValue = $("select option:contains('#{dropDownValue}')").attr('data-camel-value')
          @org_admin.set('role', camelValue)


