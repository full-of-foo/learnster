@Learnster.module "Routers", (Routers, App, Backbone, Marionette, $, _) ->

  class Routers.AppRouter extends Marionette.AppRouter

    before: (route, params) ->
      App.vent.trigger "before:before:route", route, params
      console.log "Before route hook - #{route}: #{params}" if App.environment is "development"

      user = App.reqres.request "get:current:user"
      rootRoute = if App.rootRoute then App.rootRoute.replace('/', '') else ""

      isLoggedIn = user instanceof Object
      isEmptyRoute = App.getCurrentRoute() is null
      isSignUpRoute = /.?signup/.test(App.getCurrentRoute())
      isLoginRoute = /.?login/.test(App.getCurrentRoute())
      isAboutRoute = /.?about/.test(App.getCurrentRoute())
      isTestimonialsRoute = /.?testimonials/.test(App.getCurrentRoute())

      isSessionRoute = (not isSignUpRoute and not isLoginRoute and not isAboutRoute and
                        not isTestimonialsRoute)
      isRootRoute = App.getCurrentRoute() is rootRoute
      isLegalUserRoot = ((not isEmptyRoute and isLoggedIn and isSessionRoute) or
                         (not isSessionRoute and not isLoggedIn))

      if(isEmptyRoute)
        App.execute "redirect:home"
        return false
      else if(not isLegalUserRoot)
        if not isRootRoute
          App.execute "redirect:home"
          return false
      else if(not @_permittedRoute(user, route) and user)
        console.log("#{route}: not permitted") if App.environment is "development"
        App.commands.execute("show:not:found") if route isnt "404"
        return false

    after: (route, params) ->
      App.vent.trigger "before:after:route", route, params
      console.log "After route hook - #{route}: #{params}" if App.environment is "development"

      App.setTitle(route)

      if App._isSideRoute(route)
        App.commands.execute "side:higlight:item", App.sideItemIdForRoute(route)
      else
        App.commands.execute "clear:sidebar:higlight"

    _permittedRoute: (user, route) ->
      if String(route) isnt String(/^collaborate&togetherjs=(.+)$/)
        App.isPermittedRoute(user, route)
      else
        true
