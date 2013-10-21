@Learnster.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

	class Entities.StatDataset extends Entities.Models
		defaults:
			fillColor : "rgba(220,220,220,0.5)",
			strokeColor : "rgba(220,220,220,1)",
			pointColor : "rgba(220,220,220,1)",
			pointStrokeColor : "#fff",
			dataCounts : []


	class Entities.StatDatasetCollection extends Entities.Collections
		model: Entities.StatDataset

	class Entities.Stat extends Entities.Models
		defaults:
			title: "",
			labels: [],
			dataset : new Entities.StatDataset()


	class Entities.StatCollection extends Entities.Collections
		model: Entities.Stat


	App.reqres.setHandler "set:stat:entity", (title, data, range) ->
		stat = new Entities.Stat
		stat.set('title', title)
		stat.set('range', range)
		stat.set('labels', data.labels)
		attrs = { dataCounts: data.dataset }
		dataset = new Entities.StatDataset( attrs )
		stat.set('dataset', dataset)
		stat
