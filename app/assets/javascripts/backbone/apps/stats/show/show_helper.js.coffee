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

			switch @type
				when @_getStandardStatTypes()[0] then @collection = @_fetchStudentsEnrolledFrom @id, @range
				when @_getStandardStatTypes()[1] then @collection = @_fetchAdminsEnrolledFrom @id, @range


		getData: ->
			labels = @_getMonthLabels(@range)
			datasetData = @_getDataset(labels)
			data =
				labels: labels
				datasets:
					[
						data: datasetData
					]
			data

		_getDataset: (labels) ->
			monthlyCounts = []
			# start each data month count a zero
			monthlyCounts.push 0 for monthStr in labels
			for i in [0..labels.length-1] by 1
				monthStr = labels[i]
				# increment a month count if a student enrolled on the corresonding month
				monthlyCounts[i]++ for entity in @collection.models when @_isEnrolledAtMonth entity, monthStr

			monthlyCounts



		_isEnrolledAtMonth: (entity, monthStr) ->
			createdAtMonth = Date.parse(entity.get('created_at')).toString "MMMM"
			monthStr.indexOf(createdAtMonth) isnt -1

		_getMonthLabels: (range) ->
			labels = []
			for i in [0..range-1] by 1
				monthStr = (i).months().ago().toString("MMMM")
				monthStr = monthStr.concat "\n#{(i + 1).months().ago().toString('yyyy')}" if monthStr is "January"
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





