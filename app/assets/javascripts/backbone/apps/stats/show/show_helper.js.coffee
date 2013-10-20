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

			switch @type
				when @_getStandardStatTypes()[0] then @collection = @_fetchStudentsEnrolledFrom @id, @range
				when @_getStandardStatTypes()[1] then @collection = @_fetchAdminsEnrolledFrom @id, @range


		getData: ->
			labels = @_getMonthLabels(@range)
			datasetData = @_getDataset(labels)
			data =
				labels: labels
				dataset: datasetData
			console.log data
			data



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
				perMonthCounts[key]++ for entity in @collection.models when @_isEnrolledAtDate entity, key
			value for key, value of perMonthCounts

		_getCountMonthObj: (labels) ->
			perMonthCounts = {}
			perMonthCounts[label] = 0 for label in labels
			perMonthCounts

		_isEnrolledAtDate: (entity, dateStr) ->
			# TODO fix parsing
			createdAtDate = Date.parse(entity.get('created_at'))
			intervalDate = Date.parse dateStr
			# mutation hack
			startDate = Date.parse(intervalDate.toString("dd MMMM yyyy")).add(-Math.abs(@monthInterval)).month()
			createdAtDate.between(startDate, intervalDate)

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
												months_ago: range
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





