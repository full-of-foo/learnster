@Learnster.module "StatsApp.List", (List, App, Backbone, Marionette, $, _) ->

	class List.Controller extends App.Controllers.Base

		initialize: (options = {}) ->
			statSummaries = App.request "stat:summary:entities"

			@layout = @getLayoutView()

			@listenTo @layout, "show", =>
				@showPanel(statSummaries)
				@showSummaries(statSummaries)

			@show @layout

		showSummaries: (summaries) ->
			summariesView = @getSummariesView summaries

			@listenTo summariesView, "childview:stat:summary:clicked", (child, args) ->
				navOptions = @_getSummaryToStatNavOpts args.model
				App.vent.trigger "stat:summary:clicked", navOptions

			@show summariesView,
						loading:
							loadingType: "spinner"
						region:  @layout.statSummariesRegion

		showPanel: (summaries) ->
			panelView = @getPanelView summaries

			@show panelView,
						loading:
							loadingType: "spinner"
						region:  @layout.panelRegion

		getLayoutView: ->
			new List.Layout()

		getPanelView: (summaries) ->
			new List.Panel
					collection: summaries

		getSummariesView: (summaries) ->
			new List.StatSummaries
					collection: summaries

		_getSummaryToStatNavOpts: (statSummaryEntity) ->
			user = App.request "get:current:user"
			switch user.get('type')
				when "AppAdmin" then orgId = "all"
				when "OrgAdmin" then orgId = user.get('admin_for').id
				when "Student"  then orgId = user.get('attending_org').id
			title = statSummaryEntity.get('title')
			range = 3
			{ orgId: orgId, title: title, range: range }