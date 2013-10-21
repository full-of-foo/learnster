@Learnster.module "StatsApp.Show", (Show, App, Backbone, Marionette, $, _) ->

	# Helper class which determines statistic
	# data via params supplied. A callback
	# for when a stat model is fetched
	#
	# params:
	#  id  -          orgId
	#  type -         trend
	#  range -        3, 6, 12, 24, 36, 48 or 60 months

	class Show.Helper

		constructor: (id, type = "enrollment-trend", range = 3) ->
			id = Number(id)
			range = Number(range)
			throw new Error "Statistic type '#{type}' is not available" if not @_isStandardType(type)
			throw new Error "Invalid data types suppled" 				if not @_isValidNumber(id) and not @_isValidNumber(range)
			throw new Error "Is not valid range" 						if not @_isValidRange(range)

			@id = id
			@type = type
			@range = range
			@isLayeredDataset = @range % 12 is 0 and @range isnt 12
			@yearCount = @range / 12
			@monthInterval = @_getMonthInterval()
			@trendField = @_getTrendField()

			switch @type
				when @_getStandardStatTypes()[0] then @collection = @_fetchStudentsEnrolledFrom @id, @range
				when @_getStandardStatTypes()[1] then @collection = @_fetchAdminsEnrolledFrom @id, @range
				when @_getStandardStatTypes()[2] then @collection = @_fetchStudentsUpdatedFrom @id, @range
				when @_getStandardStatTypes()[3] then @collection = @_fetchAdminsUpdatedFrom @id, @range


		getData: ->
			labelDates = @_getMonthLabels(@range)
			datasetData = @_getDataset(labelDates)
			labelsFormatted = @_formatLabels(labelDates)
			data =
				labels: labelsFormatted
				dataset: datasetData
			data

		_getTrendField: ->
			if (@type.indexOf("update") isnt -1)
				"updated_at"
			else if (@type.indexOf("enrollment") isnt -1)
				"created_at"

		_formatLabels: (labelDates) ->
			if @monthInterval is 1
				labelDates.map (date) -> Date.parse(date).toString("MMMM")
			else
				labelDates.map (date) -> Date.parse(date).toString("MMMM yyyy")

		_getMonthInterval: ->
			switch @range
				when 3 then interval = 1
				when 6 then interval = 1
				when 12 then interval = 1
				when 24 then interval = 2
				when 36 then interval = 3
				when 48 then interval = 4
				when 60 then interval = 5
			interval


		_getDataset: (labels) ->
			perMonthCounts = @_getCountMonthObj labels
			for key, value of perMonthCounts
				perMonthCounts[key]++ for entity in @collection.models when @_isOccursAtDate entity, key
			value for key, value of perMonthCounts

		_getCountMonthObj: (labels) ->
			perMonthCounts = {}
			perMonthCounts[label] = 0 for label in labels
			perMonthCounts

		_isOccursAtDate: (entity, dateStr) ->
			occurDate = Date.parse(entity.get(@trendField))
			console.log occurDate
			intervalDate = Date.parse dateStr
			# mutation hack
			startDate = Date.parse(intervalDate.toString("dd MMMM yyyy")).add(-Math.abs(@monthInterval)).month()
			occurDate.between(startDate, intervalDate)

		_getMonthLabels: (range) ->
			labels = []
			switch @monthInterval
				when 1 then multiplier = 1
				when 2 then multiplier = 2
				when 3 then multiplier = 3
				when 4 then multiplier = 4
				when 5 then multiplier = 5

			maxLength = if @monthInterval > 1 then 12 else @range
			for i in [0..maxLength-1]
						monthStr = (i * multiplier).months().ago().toString "dd MMMM yyyy"
						labels.push monthStr
			labels

		_fetchStudentsEnrolledFrom: (id, range) ->
			App.request "search:students:entities",
											term:
												search:     ""
												created_months_ago: range
											nestedId: id

		_fetchAdminsEnrolledFrom: (id, range) ->
			App.request "search:org_admins:entities",
											term:
												search:     ""
												created_months_ago: range
											nestedId: id

		_fetchStudentsUpdatedFrom: (id, range) ->
			App.request "search:students:entities",
											term:
												search:     ""
												updated_months_ago: range
											nestedId: id

		_fetchAdminsUpdatedFrom: (id, range) ->
			App.request "search:org_admins:entities",
											term:
												search:     ""
												updated_months_ago: range
											nestedId: id

		_isValidRange: (range) ->
			range in [3, 6, 12, 24, 36, 48, 60]

		_isValidNumber: (num) ->
			Object(num) instanceof Number

		_isStandardType: (type) ->
			type in @_getStandardStatTypes()

		_getStandardStatTypes: ->
			[
				"student-enrollment-trend",
				"admin-enrollment-trend",
				"student-update-trend",
				"admin-update-trend"
			]





