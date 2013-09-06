@Learnster.module "UsersApp.List", (List, App, Backbone, Marionette, $, _) ->

    List.Controller =

        listUsers: ->
            App.request "student:entities", (users) =>

                App.execute "when:fetched", users, =>
                    @layout = @getLayoutView()

                    @layout.on "show", =>
                        @showPanel users
                        @showUsers users

                    App.mainRegion.show @layout

        showNewRegion: ->
            newView = App.request "new:user:student:view"
            region = @layout.newRegion

            newView.on "form:cancel:button:clicked", =>
                region.close()

            region.show newView

        showPanel: (users) ->
            panelView = @getPanelView users

            panelView.on "new:user:student:button:clicked", =>
                @showNewRegion()

            @layout.panelRegion.show panelView

        showUsers: (users) ->
            usersView = @getUsersView users

            usersView.on "childview:user:student:clicked", (child, student) ->
                App.vent.trigger "user:student:clicked", student
            @layout.usersRegion.show usersView

        getPanelView: (users) ->
            new List.Panel
                collection: users

        getUsersView: (users) ->
            new List.Users
                collection: users

        getLayoutView: ->
            new List.Layout