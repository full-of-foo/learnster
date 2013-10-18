@Learnster.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

	class Entities.Stat extends Entities.Models
		defaults:
			title: "",
			data:  {
						labels: [],
						datasets : [
										{
											fillColor : "rgba(220,220,220,0.5)",
											strokeColor : "rgba(220,220,220,1)",
											pointColor : "rgba(220,220,220,1)",
											pointStrokeColor : "#fff",
											data : []
										}
									]
					}

	class Entities.StatCollection extends Entities.Collections
		model: Entities.Stat


	App.reqres.setHandler "set:stat:entity", (title, data) ->
		stat = new Entities.Stat
		stat.set('title', title)
		stat.get('data').labels = data.labels
		stat.get('data').datasets[0].data = data.datasets[0].data
		stat


