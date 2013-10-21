@Learnster.module "StatsApp.List", (List, App, Backbone, Marionette, $, _, Chart) ->

	class List.Layout extends App.Views.Layout
		template: "stats/list/templates/layout"
		regions:
			panelRegion: "#panel-region"
			statSummariesRegion:  "#stat-summaries-region"

	class List.Panel extends App.Views.ItemView
		template: "stats/list/templates/_panel"

	class List.StatSummary extends App.Views.ItemView
		template: "stats/list/templates/_stat_summary"
		tagName: "li"
		triggers:
			"click" : "stat:summary:clicked"

	class List.StatSummaries extends App.Views.CompositeView
		template: 'stats/list/templates/stat_summaries'
		itemView: List.StatSummary
		itemViewContainer: 'ul'
