do (Learnster, $, Backbone, Marionette, _) ->

  _.extend Backbone.Marionette.Application::,

    _userRoutes:
        shared: [
          /^organisation\/(.+?)\/students$/,
          /^login$/,
          /^statistics$/,
          /^404$/
        ]

        student: [

        ],

        orgAdmin: [
          /^organisation\/(.+?)\/admins$/,
          /^student\/(.+?)\/edit$/,
          /^org_admin\/(.+?)\/edit$/,
          /^organisation\/(.+?)\/edit$/,
          /^statistic\/(.+)\/(.+)\/(.+)$/,
          /^organisation\/(.+?)\/notifications$/
        ],

        appAdmin: [
          /^organisations$/,
          /^students$/,
          /^admins$/,
          /^notifications$/
        ]

    getAppAdminRoutes: ->
      _.flatten(@_userRoutes)

    getStudentRoutes: ->
      @_userRoutes.shared.concat(@_userRoutes.student)

    getOrgAdminRoutes: ->
      @getStudentRoutes()
        .concat(@_userRoutes.orgAdmin)

    isRouteMatching: (validRoutes, route) ->
      ((validRoutes.filter (reg) -> reg.test(route)).length > 0)

    isPermittedRoute: (user, route) ->
      if user instanceof Learnster.Entities.AppAdmin then isValid = @isRouteMatching(@getAppAdminRoutes(), route)
      if user instanceof Learnster.Entities.OrgAdmin then isValid = @isRouteMatching(@getOrgAdminRoutes(), route)
      if user instanceof Learnster.Entities.Student  then isValid = @isRouteMatching(@getStudentRoutes(), route)
      isValid

