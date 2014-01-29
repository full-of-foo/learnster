@Learnster.module "Routers", (Routers, App, Backbone, Marionette, $, _) ->

  class Routers.AppRouter extends Marionette.AppRouter

    before: (route, params) ->
      console.log "Before route hook - #{route}: #{params}" if App.environment is "development"
      user = App.reqres.request "get:current:user"
      isLoggedIn = user instanceof Object
      isEmptyRoute = App.getCurrentRoute() is null
      isSignUpRoute = /.?signup/.test(App.getCurrentRoute())
      isLoginRoute = /.?signup/.test(App.getCurrentRoute())
      isSessionRoute = not isSignUpRoute and not isLoginRoute
      isRootRoute = App.getCurrentRoute() is App.rootRoute.replace('/', '')
      isLegalUserRoot = ((not isEmptyRoute and isLoggedIn and isSessionRoute) or
                         (not isSessionRoute and not isLoggedIn))

      if(isEmptyRoute)
        App.execute "redirect:home"
        return false
      else if(not isLegalUserRoot)
        if not isRootRoute
          App.execute "redirect:home"
          return false
      else if(not App.isPermittedRoute(user, route) and user)
        console.log("#{route}: not permitted") if App.environment is "development"
        App.commands.execute("show:not:found") if route isnt "404"
        return false

    after: (route, params) ->
      console.log "After route hook - #{route}: #{params}" if App.environment is "development"
