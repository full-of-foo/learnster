class Learnster.Routers.Users extends Backbone.Router
    routes:
        '': 'index'

    initialize: ->
        @collection = new Learnster.Collections.Users()
        @collection.fetch({reset: true})

    index: ->
        view = new Learnster.Views.UsersIndex(collection: @collection)
        $('#container').html(view.render().el)
