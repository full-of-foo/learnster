@Learnster.module "SessionApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  class Show.Controller extends App.Controllers.Base

    initialize: ->
      session = App.request "new:user:session"
      @layout = @getLayoutView()

      @listenTo session, "created", (userSession) ->
        App.userSession    = userSession
        userAttrs          = userSession.attributes
        currentUser        = App.request "set:current:user", userAttrs
        currentUser._fetch = userSession._fetch

        @_setUserCookies(currentUser)
        @_setTokenHeaderToRequests(currentUser)
        App.vent.trigger "session:created", currentUser

      @listenTo @layout, "show", ->
        @showPanel()
        @showForm(session)

      @show @layout

    showPanel: ->
      panelView = @getPanelView()
      @layout.panelRegion.show panelView

    showForm: (session) ->
      formView = @getFormView(session)
      formView = App.request "form:wrapper", formView
      @layout.formRegion.show formView

    getPanelView: ->
      new Show.Panel()

    getFormView: (session) ->
      new Show.Form
        model: session

    getLayoutView: ->
      new Show.Layout()

    _setUserCookies: (currentUser) ->
      $.cookie('user_id', currentUser.get('id'))
      $.cookie('user_type', currentUser.get('type'))

    _setTokenHeaderToRequests: (currentUser) ->
      $.ajaxSetup
        headers:
          'Authorization': "Token token=\"#{currentUser.get('access_token')}\""

