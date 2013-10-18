@Learnster.module "StatsApp.Show", (Show, App, Backbone, Marionette, $, _) ->

    class Show.Controller extends App.Controllers.Base

        initialize: (options = {}) ->
           title = options.title

           # TODO - get data - request stat helper (finds data via title)

           statEntity = App.request "set:stat:entity", title, data
           statView = @getStatView statEntity

           @show statView


        getStatView: (statEntity) ->
        	new Show.StatChart
        			model: statEntity
