@Learnster.module "StatsApp.Show", (Show, App, Backbone, Marionette, $, _) ->

    class Show.Controller extends App.Controllers.Base

        initialize: (options = {}) ->
           # statEntity = App.request "get:stat:entity", options.title

           statEntity = App.request("get:default:stat:collection")

           statView = @getStatView statEntity

           @show statView


        getStatView: (statEntity) ->
        	new Show.StatChart
        			model: statEntity
