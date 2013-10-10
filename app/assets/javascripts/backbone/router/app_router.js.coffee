@Learnster.module "Router", (Router, App, Backbone, Marionette, $, _) ->

    class Router.AppRouter extends Marionette.AppRouter

        route: (route, methodName, methodBinding) ->
                super(route, methodName, methodBinding)
