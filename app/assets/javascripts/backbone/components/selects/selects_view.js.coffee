@Learnster.module "Components.Selects", (Selects, App, Backbone, Marionette, $, _) ->

  class Selects.OrgOption extends App.Views.ItemView
    template: "selects/templates/_org_option"
    tagName: "option"

  class Selects.UserOption extends App.Views.ItemView
    template: "selects/templates/_user_option"
    tagName: "option"

  class Selects.Wrapper extends App.Views.CompositeView
    template: "selects/templates/select"
    itemViewContainer: "select"

    onShow: ->
        $('.selectpicker').selectpicker()
        $(@itemViewContainer).attr("id", @options.itemViewId)

