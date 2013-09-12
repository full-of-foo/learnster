@Learnster.module "UsersApp.List", (List, App, Backbone, Marionette, $, _) ->

    class List.Controller extends App.Controllers.Base

        initialize : ->
            App.request "student:entities", (users) =>
                App.execute "when:fetched", users, =>
                    @layout = @getLayoutView()

                    @listenTo @layout, "show", =>
                        @showPanel users
                        @showUsers users
 
                    @show @layout

        showNewRegion: ->
            App.execute "new:student:view", @layout.newRegion

        showPanel: (users) ->
            panelView = @getPanelView users

            @listenTo panelView, "new:user:student:button:clicked", =>
                @showNewRegion()

            @layout.panelRegion.show panelView

        showUsers: (users) ->
            usersView = @getUsersView users

            @listenTo usersView, "childview:user:student:clicked", (child, args) ->
                App.vent.trigger "user:student:clicked", args.model

            @listenTo usersView, "childview:student:delete:clicked", (child, args) ->
                model = args.model
                console.log args
                if confirm "Are you sure you want to delete #{model.get('first_name')}?" then model.destroy() else false

            @layout.usersRegion.show usersView

        getPanelView: (users) ->
            new List.Panel
                collection: users

        getUsersView: (users) ->
            new List.Users
                collection: users

        getLayoutView: ->
            new List.Layout