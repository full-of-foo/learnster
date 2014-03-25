@Learnster.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

	class Entities.StatType extends Entities.Models

	class Entities.StatTypeCollection extends Entities.Collections
		model: Entities.StatType

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

	API =
		setStatEntity: (title, data, range, size) ->
			stat = new Entities.Stat
			stat.set('title', title)
			stat.set('range', range)
			stat.set('labels', data.labels)
			stat.set('size', size)
			attrs = { dataCounts: data.dataset }
			dataset = new Entities.StatDataset( attrs )
			stat.set('dataset', dataset)
			stat

		getDefaultStatTypeArr: ->
			[
				{
					title: "student-enrollment-trend",
					description: "Trending of students enrolled within a given period"
				},
				{
					title: "admin-enrollment-trend",
					description: "Trending of administrators enrolled within a given period"
				},
				{
					title: "student-update-trend",
					description: "Trending of student's profile updating within a given period"
				},
				{
					title: "admin-update-trend",
					description: "Trending of administrator's profile updating within a given period"
				}
			]

		getDefaultStatTypeCollection: ->
			summariesCollection = new Entities.StatTypeCollection()
			@getDefaultStatTypeArr().map (obj) ->
				summariesCollection.add(new Entities.StatType(obj))
			summariesCollection


	App.reqres.setHandler "stat:summary:entities", ->
		API.getDefaultStatTypeCollection()

	App.reqres.setHandler "set:stat:entity", (title, data, range, size) ->
		API.setStatEntity title, data, range, size
