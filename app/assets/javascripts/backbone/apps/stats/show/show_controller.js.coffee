@Learnster.module "StatsApp.Show", (Show, App, Backbone, Marionette, $, _) ->

	class Show.Controller extends App.Controllers.Base

		initialize: (options = {}) ->
		   { orgId, type, range } = options

		   # helper fetches col via type and range
		   @helper = new Show.Helper(orgId, type, range)
		   collection = @helper.collection

		   # the assign the compute data
		   App.execute "when:fetched", collection, =>
			   data = @helper.getData()
			   statEntity = App.request "set:stat:entity", type, data
			   statView = @getStatView statEntity
			   # spin until the col is fetched
			   @show statView,
							loading:
								loadingType: "spinner"
								entities:     collection


		getStatView: (statEntity) ->
			new Show.StatChart
					model: statEntity
