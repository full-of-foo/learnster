@Learnster.module "LoginApp.Show", (Show, App, Backbone, Marionette, $, _) ->

    Show.Controller =

        showLogin: ->
            @layout = @getLayoutView()
            @layout.on "show", =>
                @showPanel()
                @showForm()

            App.mainRegion.show @layout

        showPanel: ->
            panelView = @getPanelView()
            @layout.panelRegion.show panelView

        showForm: ->
            formView = @getFormView()
            @layout.formRegion.show formView

        getPanelView: ->
            new Show.Panel()

        getFormView: ->
            new Show.Form()

        getLayoutView: ->
            new Show.Layout()
