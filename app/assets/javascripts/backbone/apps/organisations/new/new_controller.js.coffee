@Learnster.module "OrgsApp.New", (New, App, Backbone, Marionette, $, _) ->

	class New.Controller extends App.Controllers.Base

		initialize: (options) ->
            org = App.request "new:org:entity"
            layout = @getLayoutView org
            @newView = @getNewView org

            @listenTo org, "created", ->
                App.vent.trigger "org:created", org

            @listenTo layout, "show", =>
                @newView = @getNewView org

                @listenTo @newView, "form:cancel", =>
                    @region.close()

                formView = App.request "form:wrapper", @newView
                layout.formRegion.show formView

            @show layout


        getLayoutView: (org) ->
            new New.Layout
                    model: org


		getNewView: (org) ->
			new New.View 
                    model: org