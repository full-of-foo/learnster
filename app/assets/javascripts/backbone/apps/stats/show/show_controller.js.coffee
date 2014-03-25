@Learnster.module "StatsApp.Show", (Show, App, Backbone, Marionette, $, _) ->

	class Show.Controller extends App.Controllers.Base

		initialize: (options = {}) ->
			{ @orgId, @title, @range } = options

			# helper fetches col via title and range
			@helper = new Show.Helper(@orgId, @title, @range)
			collection = @helper.collection

			@layout = @getLayoutView()

			@listenTo @layout, "show", =>
				@showPanel collection
				@showStat collection, @title

			@show @layout

		showStat: (collection) ->
			statView = @getStatView()
			@show statView,
						loading:
							loadingType: "spinner"
							entities:     collection
						region: @layout.statRegion

			App.execute "when:fetched", collection, =>
				data = @helper.getData()
				statEntity = App.request "set:stat:entity", @title, data, @range, collection.size()
				statView.model = statEntity
				statView.render()
				statView.drawChart()


		showPanel: (collection) ->
			panelView = @getPanelView(collection)

			options =
				orgId: @orgId
				title: @title

			@listenTo panelView, "range:list:3:clicked", ->
				options['range'] = 3
				App.vent.trigger "stat:range:item:clicked", options
			@listenTo panelView, "range:list:6:clicked", ->
				options['range'] = 6
				App.vent.trigger "stat:range:item:clicked", options
			@listenTo panelView, "range:list:12:clicked", ->
				options['range'] = 12
				App.vent.trigger "stat:range:item:clicked", options
			@listenTo panelView, "range:list:24:clicked", ->
				options['range'] = 24
				App.vent.trigger "stat:range:item:clicked", options
			@listenTo panelView, "range:list:36:clicked", ->
				options['range'] = 36
				App.vent.trigger "stat:range:item:clicked", options
			@listenTo panelView, "range:list:48:clicked", ->
				options['range'] = 48
				App.vent.trigger "stat:range:item:clicked", options
			@listenTo panelView, "range:list:60:clicked", ->
				options['range'] = 60
				App.vent.trigger "stat:range:item:clicked", options

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
