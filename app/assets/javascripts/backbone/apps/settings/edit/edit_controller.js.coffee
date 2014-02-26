@Learnster.module "SettingsApp.Edit", (Edit, App, Backbone, Marionette, $, _) ->

  class Edit.Controller extends App.Controllers.Base

    initialize: (options) ->
      id = options.id
      @user = App.reqres.request("fetch:current:user", $.cookie('user_id'), $.cookie('user_type'))

      @listenTo @user, "updated", ->
        App.vent.trigger "user:updated", @user

      App.execute "when:fetched", @user, =>
        @layout = @getLayoutView @user
        @listenTo @layout, "show", =>
          @setTitleRegion @user
          @setFormRegion @user

        @show @layout

    getLayoutView: (user) ->
      new Edit.Layout
        model: user

    getEditView: (user) ->
      new Edit.User
        model: user

    getTitleView: (user) ->
      new Edit.Title
        model: user

    setFormRegion: (user) ->
      @editView = @getEditView user

      @listenTo @editView, "form:cancel", ->
        App.vent.trigger "user:cancelled", user

      formView = App.request "form:wrapper", @editView

      if user.get('type') is "OrgAdmin"
        @listenTo @editView, "show", ->
          @setRoleSelector()

      @show formView,
        loading:
          loadingType: "spinner"
        region:  @layout.formRegion

    setRoleSelector: ->
      roles = App.request "role:entities"

      selectView = App.request "selects:wrapper",
        collection: roles
        itemViewId: "formatted_role"
        itemView:   App.Components.Selects.RoleOption

      @listenTo selectView, "show", ->
        _.delay(( => @_bindSelectChange()) , 400)

      @listenTo selectView, "close", ->
        $('select#formatted_role').unbind('change')

      console.debug @editView

      @show selectView,
        loading:
          loadingType: "spinner"
        region: @editView.roleSelectRegion


    _bindSelectChange: ->
      $('.selectpicker').selectpicker('val', @user.get('formatted_role'));

      $('select#formatted_role').on 'change', =>
          dropDownValue = $("#role-select-region .filter-option").text().trim()
          camelValue = $("select option:contains('#{dropDownValue}')").attr('data-camel-value')
          @user.set('role', camelValue)


    setTitleRegion: (user) ->
      titleView = @getTitleView user
      @show titleView,
        loading:
          loadingType: "spinner"
        region:  @layout.titleRegion
