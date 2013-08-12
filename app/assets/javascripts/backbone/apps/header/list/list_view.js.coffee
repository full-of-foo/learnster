@Learnster.module "HeaderApp.List", (List, App, Backbone, Marionette, $, _) ->

    class List.Header extends Marionette.ItemView
        template: 'header/list/templates/_header'
        tagName: 'li'

    class List.Headers extends Marionette.CompositeView
        template: 'header/list/templates/headers'
        itemView: List.Header
        itemViewContainer: 'ul'