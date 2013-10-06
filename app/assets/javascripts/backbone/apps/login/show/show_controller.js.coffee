@Learnster.module "LoginApp.Show", (Show, App, Backbone, Marionette, $, _) ->

    class Show.Controller extends App.Controllers.Base

        initialize: ->
            session = App.request "new:user:session"

            @layout = @getLayoutView()

            @listenTo session, "created", ->
                App.vent.trigger "session:created", session

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
