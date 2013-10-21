@Learnster.module "StatsApp.Show", (Show, App, Backbone, Marionette, $, _) ->

	class Show.Controller extends App.Controllers.Base

		initialize: (options = {}) ->
			{ orgId, title, range } = options

			# helper fetches col via title and range
			@helper = new Show.Helper(orgId, title, range)
			collection = @helper.collection

			@layout = @getLayoutView()

			@listenTo @layout, "show", =>
				@showPanel collection
				@showStat collection, title

			@show @layout

		showStat: (collection, title) ->
			statView = @getStatView()
			@show statView,
						loading:
							loadingType: "spinner"
							entities:     collection
						region: @layout.statRegion

			App.execute "when:fetched", collection, =>
				data = @helper.getData()
				statEntity = App.request "set:stat:entity", title, data
				statView.model = statEntity
				statView.render()
				statView.drawChart()


		showPanel: (collection) ->
			panelView = @getPanelView(collection)
			@show panelView,
						loading:
							loadingType: "spinner"
						region:  @layout.panelRegion

		getLayoutView: ->
			new Show.Layout()

		getPanelView: (collection) ->
			new Show.Panel
					collection: collection

		getStatView:  ->
			new Show.StatChart()
