@Learnster.module "StatsApp.Show", (Show, App, Backbone, Marionette, $, _, Chart) ->

    class Show.StatChart extends App.Views.ItemView
        template: "stats/show/templates/stat_chart"

        onShow: (options) ->
        	data = @model.get('data')

        	@ctx = $("#chart").get(0).getContext("2d")
        	@chart = new Chart(@ctx)
        	new Chart(@ctx).Line(data, null)


, Chart

