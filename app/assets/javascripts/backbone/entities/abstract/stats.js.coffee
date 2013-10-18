@Learnster.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

    class Entities.Stat extends Entities.Models

    class Entities.StatCollection extends Entities.Collections
        model: Entities.Stat


    API =
        getDefaultStatCollection: ->
            stats = [
                {
                    title: "test",
                    data:  {
                                labels: ["January","February","March","April","May","June","July"],
                                datasets : [
                                                {
                                                    fillColor : "rgba(220,220,220,0.5)",
                                                    strokeColor : "rgba(220,220,220,1)",
                                                    pointColor : "rgba(220,220,220,1)",
                                                    pointStrokeColor : "#fff",
                                                    data : [65,59,90,81,56,55,40]
                                                }
                                            ]
                            }
                }
            ]
            @statCollection ||= new Entities.StatCollection(stats)

    App.reqres.setHandler "get:default:stat:collection", ->
        API.getDefaultStatCollection().models[0]

