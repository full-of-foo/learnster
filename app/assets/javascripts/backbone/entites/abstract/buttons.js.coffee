@Learnster.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

    class Entities.Button extends Entities.Models

    class Entities.ButtonCollection extends Entities.Collections
        model: Entities.Button


     API = 
     	getFormButtons: (buttons, model) ->
     		buttons = @getDefaultButtons buttons, model

     		array = []
     		array.push { type: "cancel",  className: "btn",			    text: buttons.cancel } unless buttons.cancel is false
     		array.push { type: "primary", className: "btn btn-success", text: buttons.primary } unless buttons.primary is false

     		array.reverse() if buttons.placement is "pull-right"

     		buttonCollection = new Entities.ButtonCollection array
     		buttonCollection.placement = buttons.placement
     		buttonCollection


     	getDefaultButtons: (buttons, model) ->
     		_.defaults buttons,
     			primary: if model.isNew() then "Create" else "Update"
     			cancel: "Cancel"
     			placement: "pull-right"


    App.reqres.setHandler "form:button:entities", (buttons = {}, model) ->
    	API.getFormButtons buttons, model