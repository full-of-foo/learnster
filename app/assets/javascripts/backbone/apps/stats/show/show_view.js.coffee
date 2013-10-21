@Learnster.module "StatsApp.Show", (Show, App, Backbone, Marionette, $, _, Chart) ->

	class Show.Layout extends App.Views.Layout
		template: "stats/show/templates/layout"
		regions:
			panelRegion: "#panel-region"
			statRegion:  "#stat-region"

	class Show.Panel extends App.Views.ItemView
		template: "stats/show/templates/_panel"
		events:
			"click #chart-as-jpeg" : "saveJpeg"
			"click #chart-as-png" : "savePng"

		saveJpeg: (e) ->
			e.preventDefault()
			Canvas2Image.saveAsJPEG($("#chart")[0])

		savePng: (e) ->
			e.preventDefault()
			Canvas2Image.saveAsPNG($("#chart")[0])

	class Show.StatChart extends App.Views.ItemView
		template: "stats/show/templates/show_chart"
		modelEvents:
			"change" : "render"

		drawChart: ->
			data = @_deriveModelData()
			@ctx = $("#chart").get(0).getContext("2d")
			@chart = new Chart(@ctx)
			new Chart(@ctx).Line(data, null)

		_deriveModelData: ->
			console.log @model
			data =
				labels   : @model.get('labels'),
				datasets : [
					@_getDataSetAttrs(@model.get('dataset'))
				]


		_getDataSetAttrs: (datasetEntity) ->
				{
					fillColor:  	  datasetEntity.get('fillColor'),
					strokeColor: 	  datasetEntity.get('strokeColor'),
					pointColor: 	  datasetEntity.get('pointColor'),
					pointStrokeColor: datasetEntity.get('pointStrokeColor'),
					data: 			  datasetEntity.get('dataCounts')
				}






, Chart

