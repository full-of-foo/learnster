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

      @show formView,
        loading:
          loadingType: "spinner"
        region:  @layout.formRegion


    setTitleRegion: (user) ->
      titleView = @getTitleView user
      @show titleView,
        loading:
          loadingType: "spinner"
        region:  @layout.titleRegion
